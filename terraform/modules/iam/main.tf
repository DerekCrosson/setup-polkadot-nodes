resource "aws_iam_group_membership" "managing_users_group_membership" {
  name = "${ var.group_name }-membership"
  users = [ aws_iam_user.managing_user.id ]
  group = aws_iam_group.managing_users_group.name
}

resource "aws_iam_group" "managing_users_group" {
  name = "${ var.group_name }"
}

resource "aws_iam_group_policy_attachment" "certificate-manager-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCertificateManagerFullAccess"
}

resource "aws_iam_group_policy_attachment" "vpc-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_group_policy_attachment" "s3-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy_attachment" "secrets-manager-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_group_policy_attachment" "iam-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_group_policy_attachment" "ec2-container-registry-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_group_policy_attachment" "ec2-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "ecs-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_group_policy_attachment" "cloudwatch-logs-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_group_policy_attachment" "decode-authorization-message-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = aws_iam_policy.decode-authorization-message-policy.arn
}

resource "aws_iam_policy" "decode-authorization-message-policy" {
  name        = "${ var.custom_policy_name }"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
            {
                "Sid": "AllowStsDecode",
                "Effect": "Allow",
                "Action": "sts:DecodeAuthorizationMessage",
                "Resource": "*"
            }
        ]
    })
}

resource "aws_iam_access_key" "managing_user_access_key" {
  user = aws_iam_user.managing_user.name
}
resource "aws_iam_user" "managing_user" {
  name = "polkadot"

  tags = {
    tag-key = "polkadot"
  }
}
