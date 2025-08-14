output "iam_role_name" {
  value = aws_iam_role.allow_s3_for_ec2.name
}
output "profile_name" {
  value = aws_iam_instance_profile.instance_profile.name
}