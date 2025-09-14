module "dns" {
  source      = "./../modules/dns"
  domain_name = var.domain_name
  rg_location = var.rg_location
}

module "bastion" {
  source      = "./../modules/networks/bastion"
  rg_location = var.rg_location
}