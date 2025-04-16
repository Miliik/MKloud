module "vpc" {
  source  = "./vpc"
  vpcname = "kcvpc"
  my_ip   = chomp(data.http.myip.body)
  public_cidr_block = "10.0.1.0/24"
  private_cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-3a"
  vpc_cidr_block  =  "10.0.0.0/16"
  private_subnet_tag_name = "tf-private-subnet"
  public_subnet_tag_name = "tf-public-subnet"
}
#test
module "ec2_instance" {
  source            = "./ec2_instance"
  instance_name     = "kungfu"
  public_subnet_id  = module.vpc.public_subnet_id
  vpc_id            = module.vpc.vpc_id
  security_group_id = module.vpc.security_group_id
  instance_type    = "t2.micro"
}

module "s3_bucket" {
  source                        = "./s3_bucket"
  bucket_name                   = "mkcbucket"
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
  kms_arn     = module.kms.kms_key_arn

  users_map = {

    kungfu2 = "dev"
    milan = "admin"
    kc = "read_only"# This assigns kungfu to the 'admin' group
  }
}




data "http" "myip" {
  url = "http://ipv4.icanhazip.com/"
}
