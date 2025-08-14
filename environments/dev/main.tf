/////////////////////////////////VPC\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = local.cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  map_public_ip_on_launch =  true
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = local.tags
}
///////////////////////////////////////////Security Groups\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
module "security_group" {
  source = "../../custom-modules/SecurityGroups"
  vpc_id = module.vpc.vpc_id
  cidr_ingress = local.private_subnets[0]
  tags = local.tags
}
//////////////////////////////////S3\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = local.s3_bucket_name
  versioning = {
    enabled = true
  }
  tags = local.tags
}

data "aws_iam_policy_document" "public_read_policy" {
  statement {
    sid       = "PublicReadGetObject"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${local.s3_hosting_bucket_name}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
  statement {
    sid       = "AllPermission"
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${local.s3_hosting_bucket_name}/*"]

    principals {
      type        = "AWS"
      identifiers = ["368062698386"]
    }
  }
}

module "s3_hosting_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = local.s3_hosting_bucket_name
  website = {
     index_document = "index.html"
     error_document = "error.html"
  }
   attach_policy = true
   policy = data.aws_iam_policy_document.public_read_policy.json
  #  cors_rule = [
  #   {
  #     allowed_methods = ["GET"]
  #     allowed_origins = ["*"]
  #     allowed_headers = ["*"]
  #     expose_headers  = ["ETag"]
  #     max_age_seconds = 3000
  #     }
  # ]
   block_public_acls       = false
   block_public_policy     = false
   ignore_public_acls      = false
   restrict_public_buckets = false
   tags = local.tags
}

/////////////////////////////////////////IAM Roles\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
module "iam" {
  source = "../../custom-modules/roles"
  s3_bucket_arn = module.s3_bucket.s3_bucket_arn
  tags = local.tags
}

//////////////////////////////////////////////Instances\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
module "api_server" {
  source = "../../custom-modules/ec2"

  name             = "instance-tf1-public"
  ami              = local.ami_id
  instance_type    = local.instance_type
  key_name         = local.key_name
  subnet_id        = module.vpc.public_subnets[0]
  security_group_ids = module.security_group.sg_ids
  # iam_role_name    = "Ec2s3policy"
  associate_public_ip = true
  tags             = local.tags
  instance_profile_name = module.iam.profile_name
  ssh_user         = local.ssh_user
  private_key_path = local.private_key_path
  script_path      = local.script_path
  dest_script_path = local.dest_script_path
  s3_bucket_name   = local.s3_bucket_name
}