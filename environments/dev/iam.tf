module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "6.1.0"

  name        = "s3_get_policy_${terraform.workspace}"
  path        = "/"
  description = "This policy will allow read s3 bucket"

  policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "s3:ListBucket"
          ],
          "Effect": "Allow",
          "Resource": "${module.s3_bucket.s3_bucket_arn}"
        }
      ]
    }
  EOF

  depends_on = [ module.s3_bucket ]
  tags       = local.tags
}

module "iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.1.0"

  name                   = "EC2RoleToAccesBucket_${terraform.workspace}"
  create_instance_profile = true

  trust_policy_permissions = {
    TrustRoleAndServiceToAssume = {
      actions = ["sts:AssumeRole"]
      principals = [{
        type = "Service"
        identifiers = ["ec2.amazonaws.com"]
      }]
    }
  }

  policies = {
    AmazonS3ListOnly = module.iam_policy.arn
  }

  depends_on = [ module.iam_policy ]
  tags       = local.tags
}
