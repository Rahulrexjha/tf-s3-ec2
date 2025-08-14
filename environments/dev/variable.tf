variable "env" {
  description = "Environment Type"
}
variable "ami_id" {
  description = "Amazon machine image"
}
variable "private_subnets" {
  description = "private subnet cidr"
}
variable "public_subnets" {
  description = "public subnet cidr"
}
variable "azs" {
  description = "availability zones"
}
variable "cidr" {
  description = "cidr range for vpc"
}
variable "s3_bucket_name" {
  description = "S3 hosting bucket"
}
variable "s3_hosting_bucket_name" {
  description = "s3 hosting bucket name "
}
variable "script_path" {
  description = "script path to setup server"
}
variable "dest_script_path" {
  description = "script destination"
}
variable "private_key_path" {
  description = "private key path"
}
variable "instance_type" {
  description = "instance type"
}
variable "key_name" {
  description = "SSH key"
}
variable "ssh_user" {
  description = "ssh_user"
}