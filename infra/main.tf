provider "aws" {
  region  = var.region
  profile = var.profile
  default_tags {
    tags = {
      Enviroment = "${terraform.workspace}"
    }
  }
}


module "iam" {
  source = "./iam"
}

module "networking" {
  source = "./networking"
}

module "security_group" {
  source = "./security_group"
  vpc_id = module.networking.vpc_id
}

module "computing" {
  source                = "./computing"
  ec2_security_group_id = module.security_group.ec2_security_group_id
  public_subnet_id      = module.networking.public_subnet_id
  instance_profile_name = module.iam.instance_profile_name
  key_name              = var.key_name
  ami_ubuntu_id         = var.ami_ubuntu_id
}


output "eip_address" {
  value = module.computing.eip_address
}