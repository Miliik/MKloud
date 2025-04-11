locals {
  groups = distinct(values(var.users_map))
}

# IAM Groups
resource "aws_iam_group" "groups" {
  for_each = toset(["dev", "read_only", "admin"])
  name     = "tf-${each.value}-group"
}

# IAM Users
resource "aws_iam_user" "users" {
  for_each      = var.users_map
  name          = "tf-${each.key}-user"
  force_destroy = true
}

# IAM Access Keys
resource "aws_iam_access_key" "access_keys" {
  for_each = var.users_map
  user     = aws_iam_user.users[each.key].name
}

# IAM Group Membership
resource "aws_iam_user_group_membership" "group_membership" {
  for_each = var.users_map
  user     = aws_iam_user.users[each.key].name
  groups   = [aws_iam_group.groups[each.value].name]
}

# Group to Policy Mapping

resource "aws_iam_policy_attachment" "group_policies" {
  for_each = {
    admin      = "arn:aws:iam::aws:policy/AdministratorAccess"
    dev        = "arn:aws:iam::aws:policy/PowerUserAccess"
    read_only  = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }

  name       = "${each.key}-policy-attachment"
  policy_arn = each.value
  groups     = [aws_iam_group.groups[each.key].name]
}

# Custom Fake Admin Policy (example dev policy)
resource "aws_iam_policy" "fake_admin_policy" {
  name = "tf-fake-admin-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:DescribeInstances"]
        Resource = "*"
      }
    ]
  })
}

# KMS Policy for a specific user (can be enhanced with lookup logic if per-user needed)
resource "aws_iam_policy" "kms_usage_policy" {
  name        = "kms_usage_policy"
  description = "Policy to allow KMS encrypt and decrypt actions"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = var.kms_arn
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "kms_user_policy" {
  for_each   = var.users_map
  user       = aws_iam_user.users[each.key].name
  policy_arn = aws_iam_policy.kms_usage_policy.arn
}

# Temp Admin Role
resource "aws_iam_role" "temp_admin_role" {
  name = "tf-temp-admin-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = [for u in aws_iam_user.users : u.arn]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Admin Privileges for Temp Role
resource "aws_iam_policy" "temp_admin_policy" {
  name = "tf-temp-admin-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "*",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "temp_admin_policy_attach" {
  role       = aws_iam_role.temp_admin_role.name
  policy_arn = aws_iam_policy.temp_admin_policy.arn
} 