module "network" {
  source             = "../../modules/network"
  env_01             = var.env_01
  region             = var.region
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}
