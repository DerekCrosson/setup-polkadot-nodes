resource "aws_iam_group_membership" "managing_users_group_membership" {
  name = "${ var.group_name }-membership"
  users = [ data.aws_iam_user.managing_user.id ]
  group = aws_iam_group.managing_users_group.name
}

resource "aws_iam_group" "managing_users_group" {
  name = "${ var.group_name }"
}

resource "aws_iam_group_policy_attachment" "certificate-manager-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/CertificateManagerFullAccess"
}

resource "aws_iam_group_policy_attachment" "vpc-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/VPCFullAccess"
}

resource "aws_iam_group_policy_attachment" "s3-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy_attachment" "secrets-manager-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerFullAccess"
}

resource "aws_iam_group_policy_attachment" "iam-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_group_policy_attachment" "ec2-container-registry-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/EC2ContainerRegistryFullAccess"
}

resource "aws_iam_group_policy_attachment" "ec2-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/EC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "ecs-attachment" {
  group      = aws_iam_group.managing_users_group.name
  policy_arn = "arn:aws:iam::aws:policy/ECSFullAccess"
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

data "aws_iam_user" "managing_user" {
  user_name = "${ var.username }"
}
