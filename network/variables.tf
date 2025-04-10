variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "dmz_subnet_cidr" {
  description = "CIDR block for the DMZ subnet"
  type        = string
}

variable "back_subnet_cidr" {
  description = "CIDR block for the back subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the subnets"
  type        = string
}