env               = "prod"
ami_id            = "ami-0f918f7e67a3323f0"
instance_type     = "t3.medium"

cidr              = "10.1.0.0/16"
private_subnets   = ["10.1.1.0/24", "10.1.2.0/24"]
public_subnets    = ["10.1.101.0/24", "10.1.102.0/24"]
azs               = ["ap-south-1a", "ap-south-1b"]

s3_bucket_name        = "ec2-test-bucket-13-08-2025-prod"
s3_hosting_bucket_name= "ec2-test-bucket-13-08-2025-hosting-prod"
index_document="index.html"
error_document="error.html"


script_path       = "../../scripts/setup-app.sh"
dest_script_path  = "/tmp/setup-api-server.sh"
private_key_path  = "C:/Users/Chiranjib/Desktop/PEM/primary.pem"
ssh_user          = "ubuntu"
key_name          = "primary"
instance_name     = "tf-instance-prod"
