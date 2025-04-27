variable "users_map" {
  description = "Map of usernames to groups (e.g. { alice = \"read_only\", bob = \"dev\" })"
  type        = map(string)
}

variable "kms_arn" {
  description = "KMS Key ARN for encryption permissions"
  type        = string
}

variable "group_policy_arns" {
  description = "Map of group names to their respective policy ARNs"
  type        = map(string)
  default = {
    admin     = "arn:aws:iam::aws:policy/AdministratorAccess"
    dev       = "arn:aws:iam::aws:policy/PowerUserAccess"
    read_only = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}

variable "group_names" {
  description = "List of IAM group names"
  type        = list(string)
  default     = ["dev", "read_only", "admin"]
}