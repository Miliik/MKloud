resource "aws_iam_user" "kungfu_user" {
  name = "tf-kungfu-user"
}

resource "aws_iam_access_key" "kungfu_user_key" {
  user = aws_iam_user.kungfu_user.name
}

output "access_key_id" {
  value = aws_iam_access_key.kungfu_user_key.id
}

output "access_key_secret" {
  value = aws_iam_access_key.kungfu_user_key.secret
}

output "username" {
  value = aws_iam_user.kungfu_user.name
}
output "iam_user_names" {
  value = [for user in aws_iam_user.users : user.name]
}

output "iam_group_names" {
  value = [for group in aws_iam_group.groups : group.name]
}

output "temp_admin_role_arn" {
  value = aws_iam_role.temp_admin_role.arn
}
