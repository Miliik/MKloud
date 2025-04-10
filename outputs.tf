output "instance_ip_addr" {
  value = module.ec2_instance.instance_ip_addr
}

output "kms_key_id" {
    value = module.kms.kms_key_id
}

# output creds for user created in iam module
#output "access_key_id" {
#  value = module.iam.access_key_id
#  sensitive = false
#}
#output "secret_access_key" {
#  value = module.iam.access_key_secret
#  sensitive = false
#}
