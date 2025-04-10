output "kms_key_id" {
  value = aws_kms_key.KCMSKey.id
}

# output the aws_kms_key
output "kms_key_arn" {
  value = aws_kms_key.KCMSKey.arn
}