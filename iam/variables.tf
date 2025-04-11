variable "users_map" {
  description = "Map of usernames to groups (e.g. { alice = \"read_only\", bob = \"dev\" })"
  type        = map(string)
}

variable "kms_arn" {
  description = "KMS Key ARN for encryption permissions"
  type        = string
}
