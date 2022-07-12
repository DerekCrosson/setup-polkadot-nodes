module "iam" {
  source = "./modules/iam"
}

module "networking" {
  source = "./modules/networking"
}

module "security" {
  source = "./modules/security"
}

module "machines" {
  source = "./modules/machines"

  subnet_id = module.networking.subnet_id
  security_groups = [
    module.security.all_nodes_security_group_id,
    module.security.rpc_nodes_security_group_id
  ]
  collator_nodes_security_group_id = module.security.collator_nodes_security_group_id
}
