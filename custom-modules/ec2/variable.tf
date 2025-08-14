variable "name" {
    description = "name of the isntance"
}
variable "ami" {
    description = "ami id"
}
variable "instance_type" {
    description = "instance_type"
}
variable "key_name" {}
variable "subnet_id" {}
variable "security_group_ids" {
  type = list(string)
}
# variable "iam_role_name" {}
variable "associate_public_ip" {
  type    = bool
  default = true
}
variable "tags" {
  type = map(string)
}

#################################################provisioner#######################################
variable "ssh_user" {
  default = "ubuntu"
}
variable "private_key_path" {}
variable "script_path" {}
variable "dest_script_path" {}
variable "s3_bucket_name" {}
variable "instance_profile_name" {}