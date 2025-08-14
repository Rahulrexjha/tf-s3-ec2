data "aws_iam_policy_document" "policy" {
    statement {
        sid="AllowRead"
        effect = "Allow"
        actions=["s3:GetObject"]
        resources = [ "${var.s3_bucket_arn}/*" ]
    }
     statement {
        sid="AllowList"
        effect = "Allow"
        actions=["s3:ListBucket"]
        resources = [ "${var.s3_bucket_arn}*" ]
    }
}

resource "aws_iam_policy" "policy" {
  name = "Ec2s3policy"
  policy = data.aws_iam_policy_document.policy.json
  tags = var.tags
}

data "aws_iam_policy_document" "assume_role" {
    statement {
        sid="AssumeRole"
        effect = "Allow"
        actions=["sts:AssumeRole"]
        principals {
          type = "Service"
          identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "allow_s3_for_ec2" {
  name = "Allows3forec2"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "attachment" {
  role = aws_iam_role.allow_s3_for_ec2.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile"
  role = aws_iam_role.allow_s3_for_ec2.name
}