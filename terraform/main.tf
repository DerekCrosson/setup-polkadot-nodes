module "iam" {
  source = "./modules/iam"
}

module "security" {
  source = "./modules/networking"
}
