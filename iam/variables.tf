variable "username" {
  type = string
}
variable "policy_name" {
  type = string
}
variable "kms_arn" {
  description = "ARN of the KMS key"
  type        = string
}