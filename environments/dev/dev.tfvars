env               = "dev1"
ami_id            = "ami-0f918f7e67a3323f0"
instance_type     = "t3.micro"

cidr              = "10.0.0.0/16"
private_subnets   = ["10.0.1.0/24"]
public_subnets    = ["10.0.101.0/24"]
azs               = ["ap-south-1a"]

s3_bucket_name        = "ec2-test-bucket-13-08-2025-dev"
s3_hosting_bucket_name= "ec2-test-bucket-13-08-2025-hosting-dev"
index_document="index.html"
error_document="error.html"

script_path       = "../../scripts/setup-app.sh"
dest_script_path  = "/tmp/setup-api-server.sh"
private_key_path  = "C:/Users/Chiranjib/Desktop/PEM/primary.pem"
ssh_user          = "ubuntu"
key_name          = "primary"
instance_name     = "tf-instance-dev"
