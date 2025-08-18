
######################################### Environment ################################################
locals {
  environment = var.env

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

######################################### VPC########################################


locals {
  cidr            = var.cidr
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  azs             = var.azs
}

######################################## S3 ########################################
locals {
  s3_bucket_name         = var.s3_bucket_name
  s3_hosting_bucket_name = var.s3_hosting_bucket_name
  index_document="index.html"
  error_document="error.html"
}

#######################################EC2######################################### 

locals {
  ami_id            = var.ami_id
  instance_name     = var.instance_name
  instance_type     = var.instance_type
  key_name          = var.key_name
  ssh_user          = var.ssh_user
  private_key_path  = var.private_key_path
  script_path       = var.script_path
  dest_script_path  = var.dest_script_path
}
