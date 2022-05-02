
variable "token" {}
variable "node_count" {}

variable "cluster_subdomain" {}

variable "domain" {}

variable "hostnames" {
  type = list
}

variable "public_ips" {
  type = list
}

provider "hetznerdns" {
  # Configuration options
  apitoken = var.token
}


data "hetznerdns_zone" "dopluk" {
    name = var.domain
}

resource "hetznerdns_record" "hosts" {
  count = var.node_count
  zone_id = data.hetznerdns_zone.dopluk.id
  type   = "A"
  ttl = 300
  name   = "${element(var.hostnames, count.index)}.${var.cluster_subdomain}"
  value  = element(var.public_ips, count.index)
}

# resource "hetznerdns_record" "domain" {
#   count = var.node_count
#   zone_id = data.hetznerdns_zone.dopluk.id
#   type   = "A"
#   ttl = 300
#   name   = "*.${element(var.workers.*.name, count.index)}.${var.cluster_subdomain}"
#   value  = element(var.workers.*.ipv4_address, count.index)
# }

resource "hetznerdns_record" "wildcard" {
  count = var.node_count
  zone_id = data.hetznerdns_zone.dopluk.id
  type   = "A"
  ttl = 3600
  name   = "*.${var.cluster_subdomain}"
  value  = element(var.public_ips, 0)
}

output "domains" {
  value = hetznerdns_record.hosts.*.value
}