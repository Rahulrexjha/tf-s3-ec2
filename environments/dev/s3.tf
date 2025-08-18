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
}

module "s3_hosting_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = local.s3_hosting_bucket_name
  website = {
    index_document =local.index_document
    error_document = local.error_document
  }

  attach_policy = true
  policy = data.aws_iam_policy_document.public_read_policy.json

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  tags = local.tags
}
