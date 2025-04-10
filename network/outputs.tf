output "vpc_id" {
  value = aws_vpc.custom_vpc.id
}

output "dmz_subnet_id" {
  value = aws_subnet.dmz_subnet.id
}

output "back_subnet_id" {
  value = aws_subnet.back_subnet.id
}