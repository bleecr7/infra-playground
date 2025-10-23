resource "cloudflare_zone" "root_domain" {
  account = {
    id = var.cloudflare_account_id
  }
  name = "brandonlee.cloud"
  type = "full"
}

resource "cloudflare_dns_record" "terraform_managed_resource_afd5c9cc25a270f369d697fec397c6bf_0" {
  content = "azure.brandonlee.cloud"
  name    = "brandonlee.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = "a289bb878c36519c99a34df2a6deb3bc"
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "terraform_managed_resource_ab9c044bc38aa5531787fe45d05de3b1_1" {
  content = "_domainconnect.ss.domaincontrol.com"
  name    = "_domainconnect.brandonlee.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = "a289bb878c36519c99a34df2a6deb3bc"
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "terraform_managed_resource_6df4263ad8743eb5f335dd95ebc799f8_2" {
  content = "brandonlee.cloud"
  name    = "www.brandonlee.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = "a289bb878c36519c99a34df2a6deb3bc"
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "terraform_managed_resource_de207d68b6372b3bcc1ccc75e2229006_3" {
  content  = "ns1-05.azure-dns.com"
  name     = "azure.brandonlee.cloud"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "NS"
  zone_id  = "a289bb878c36519c99a34df2a6deb3bc"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_cff336ab3386f6fea492857386c7d8df_4" {
  content  = "ns2-05.azure-dns.net"
  name     = "azure.brandonlee.cloud"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "NS"
  zone_id  = "a289bb878c36519c99a34df2a6deb3bc"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_3f08d69cb48fd870e6fd09b4e7fe2cd0_5" {
  content  = "ns46.domaincontrol.com"
  name     = "brandonlee.cloud"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "NS"
  zone_id  = "a289bb878c36519c99a34df2a6deb3bc"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_123d8eb2770f842ecf266316e2fac71a_6" {
  content  = "ns45.domaincontrol.com"
  name     = "brandonlee.cloud"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "NS"
  zone_id  = "a289bb878c36519c99a34df2a6deb3bc"
  settings = {}
}

resource "cloudflare_dns_record" "terraform_managed_resource_a25252396ea58d619fdd8beec6f213fe_7" {
  content  = "\"v=DMARC1; p=reject; adkim=r; aspf=r; rua=mailto:dmarc_rua@onsecureserver.net;\""
  name     = "_dmarc.brandonlee.cloud"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = "a289bb878c36519c99a34df2a6deb3bc"
  settings = {}
}