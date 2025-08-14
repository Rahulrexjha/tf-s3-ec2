module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = var.name
  ami  = var.ami
  instance_type = var.instance_type
  key_name  = var.key_name
  subnet_id  = var.subnet_id
  vpc_security_group_ids  = var.security_group_ids
#   iam_role_name = var.iam_role_name
  associate_public_ip_address = var.associate_public_ip
  iam_instance_profile = var.instance_profile_name
  monitoring = true
  tags = var.tags
}



/////////////////////////Provisioning\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resource "terraform_data" "provision" {
  depends_on = [module.ec2_instance]
  triggers_replace = {
    instance_id = module.ec2_instance.id
  }
  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.private_key_path)
    host        = module.ec2_instance.public_ip
  }

  provisioner "file" {
    source      = var.script_path
    destination = var.dest_script_path
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ${var.dest_script_path}",
      "sudo ${var.dest_script_path} ${var.s3_bucket_name}"
    ]
  }
}
