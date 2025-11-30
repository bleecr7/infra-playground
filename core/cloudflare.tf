resource "cloudflare_zone" "root_domain" {
  account = {
    id = var.cloudflare_account_id
  }
  name = "brandonlee.cloud"
  type = "full"
}

# resource "cloudflare_dns_record" "root_azure" {
#   content = "azure.brandonlee.cloud"
#   name    = "brandonlee.cloud"
#   proxied = true
#   tags    = []
#   ttl     = 1
#   type    = "CNAME"
#   zone_id = "a289bb878c36519c99a34df2a6deb3bc"
#   settings = {
#     flatten_cname = false
#   }
# }

resource "cloudflare_dns_record" "cname_domainconnect" {
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

resource "cloudflare_dns_record" "cname_www" {
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

resource "cloudflare_dns_record" "ns_azure_1" {
  content  = "ns1-05.azure-dns.com"
  name     = "azure.brandonlee.cloud"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "NS"
  zone_id  = "a289bb878c36519c99a34df2a6deb3bc"
  settings = {}
}

resource "cloudflare_dns_record" "ns_azure_2" {
  content  = "ns2-05.azure-dns.net"
  name     = "azure.brandonlee.cloud"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "NS"
  zone_id  = "a289bb878c36519c99a34df2a6deb3bc"
  settings = {}
}

resource "cloudflare_dns_record" "ns_domaincontrol_46" {
  content  = "ns46.domaincontrol.com"
  name     = "brandonlee.cloud"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "NS"
  zone_id  = "a289bb878c36519c99a34df2a6deb3bc"
  settings = {}
}

resource "cloudflare_dns_record" "ns_domaincontrol_45" {
  content  = "ns45.domaincontrol.com"
  name     = "brandonlee.cloud"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "NS"
  zone_id  = "a289bb878c36519c99a34df2a6deb3bc"
  settings = {}
}

resource "cloudflare_dns_record" "txt_dmarc" {
  content  = "\"v=DMARC1; p=reject; adkim=r; aspf=r; rua=mailto:dmarc_rua@onsecureserver.net;\""
  name     = "_dmarc.brandonlee.cloud"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = "a289bb878c36519c99a34df2a6deb3bc"
  settings = {}
}
