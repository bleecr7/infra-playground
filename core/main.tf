module "dns" {
  source   = "./../modules/dns"
  domain_name = var.domain_name
  infra_type = var.infra_type
  rg_location = var.rg_location
}

