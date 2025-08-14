output "sg_ids" {
  description = "Security group id"
  value = [aws_security_group.ec2_sg_allow_http.id]
}