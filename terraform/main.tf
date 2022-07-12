module "iam" {
  source = "./modules/iam"
}

module "networking" {
  source = "./modules/networking"
}

module "machines" {
  source = "./modules/machines"

  subnet_id = module.networking.subnet_id
}
