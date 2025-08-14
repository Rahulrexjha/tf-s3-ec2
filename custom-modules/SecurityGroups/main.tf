resource "aws_security_group" "ec2_sg_allow_http" {
  name = "allow_tls"
  vpc_id = var.vpc_id
  description = "Allowing http requests"
  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.ec2_sg_allow_http.id
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.ec2_sg_allow_http.id
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_vpc_security_group_egress_rule" "allow_egress" {
  security_group_id = aws_security_group.ec2_sg_allow_http.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}