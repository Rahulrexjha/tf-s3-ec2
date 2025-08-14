locals {
  environment=var.env
  ami_id=var.ami_id
  cidr=var.cidr
  private_subnets=var.private_subnets
  public_subnets=var.public_subnets
  azs=var.azs
  s3_bucket_name=var.s3_bucket_name
  s3_hosting_bucket_name=var.s3_hosting_bucket_name
  script_path = var.script_path
  dest_script_path=var.dest_script_path
  private_key_path=var.private_key_path
  instance_type=var.instance_type
  key_name=var.key_name
  ssh_user=var.ssh_user
  tags={
    Terraform = "true"
    Environment = var.env
  }
}