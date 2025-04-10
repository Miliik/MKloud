variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "dmz_subnet_id" {
  description = "ID of the DMZ subnet"
  type        = string
}

variable "back_subnet_id" {
  description = "ID of the back subnet"
  type        = string
}