module "network" {
  source             = "../../modules/network"
  env_01             = var.env_01
  region             = var.region
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

module "compute" {
  source            = "../../modules/compute"
  env_01            = var.env_01
  public_subnet     = module.network.public_subnet
  security_group_id = module.network.security_group_id
  instance_type     = var.instance_type
  key_pair_name     = var.key_pair_name

}