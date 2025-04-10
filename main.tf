module "ec2_instance" {
  source        = "./ec2_instance"
  my_ip         = chomp(data.http.myip.body)
  instance_name = "kungfu"
  my_default_sg_id = module.security_group.my_default_sg_id

}

module "s3_bucket" {
  source                        = "./s3_bucket"
  bucket_name                   = "mk-bucket"
  very_secret_access_key_id     = module.iam.access_key_id
  very_secret_access_key_secret = module.iam.access_key_secret
  very_secret_username          = module.iam.username
}

module "kms" {
  source = "./kms"
  kmsname = "kcms_key"
}

module "iam" {
  source      = "./iam"
  username    = "kungfu"
  policy_name = "kungfu"
  kms_arn     = module.kms.kms_key_arn
}

module "network" {
  source = "./network"

  vpc_cidr          = "10.0.0.0/16"
  dmz_subnet_cidr   = "10.0.1.0/24"
  back_subnet_cidr  = "10.0.2.0/24"
  availability_zone = "eu-west-3a"
  vpc_name          = "custom-vpc"
}

module "security_group" {
  source   = "./security_group"

  vpc_id   = module.network.vpc_id
  vpc_name = "custom-vpc"

  dmz_subnet_id  = module.network.dmz_subnet_id
  back_subnet_id = module.network.back_subnet_id
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com/"
}