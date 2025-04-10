output "public_subnet_id" {
  value = aws_subnet.public.id
}

# output the vpc id
output "vpc_id" {
  value = aws_vpc.main.id
}

output "security_group_id" {
  value = aws_security_group.kungfu_sg.id
}

