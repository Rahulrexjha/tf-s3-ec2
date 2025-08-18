module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = local.instance_name
  ami                         = local.ami_id
  instance_type               = local.instance_type
  key_name                    = local.key_name
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true
  iam_instance_profile        = module.iam_role.instance_profile_name
  monitoring                  = true
  tags                        = local.tags
}

# ------------------- Provisioning -------------------
resource "terraform_data" "provision" {
  depends_on       = [module.ec2_instance]
  triggers_replace = {
    instance_id = module.ec2_instance.id
  }

  connection {
    type        = "ssh"
    user        = local.ssh_user
    private_key = file(local.private_key_path)
    host        = module.ec2_instance.public_ip
  }

  provisioner "file" {
    source      = local.script_path
    destination = local.dest_script_path
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ${local.dest_script_path}",
      "sudo ${local.dest_script_path} ${local.s3_bucket_name}"
    ]
  }
}
