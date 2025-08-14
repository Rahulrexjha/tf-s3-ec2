terraform {
  backend "s3" {
    bucket = "int-tf-state"
    key = "state/terraform.tfstate"
    use_lockfile = true
    region = "ap-south-1"
  }
}