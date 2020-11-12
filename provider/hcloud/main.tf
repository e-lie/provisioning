variable "token" {}

variable "hosts" {
  default = 0
}

variable "hostname_format" {
  type = string
}

variable "location" {
  type = string
}

variable "type" {
  type = string
}

variable "image" {
  type = string
}

variable "ssh_keys" {
  type = list
}

variable "floating_ip_count" {
  type = number
  default = 0
}

provider "hcloud" {
  token = var.token
}

variable "apt_packages" {
  type    = list
  default = []
}

resource "hcloud_server" "host" {
  name        = format(var.hostname_format, count.index + 1)
  location    = var.location
  image       = var.image
  server_type = var.type
  ssh_keys    = var.ssh_keys

  count = var.hosts

  connection {
    user    = "root"
    type    = "ssh"
    timeout = "2m"
    host    = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "while fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do sleep 1; done",
      "apt-get update",
      "apt-get install -yq ufw ${join(" ", var.apt_packages)}",
    ]
  }
}

resource "hcloud_floating_ip" "floating_ip" {
  count = var.floating_ip_count
  type = "ipv4"
  home_location = var.location
}

resource "hcloud_floating_ip_assignment" "main" {
  count = var.floating_ip_count
  floating_ip_id = element(hcloud_floating_ip.floating_ip.*.id, count.index)
  server_id = hcloud_server.host.0.id
}

resource "null_resource" "ip_addr_add" {
  count = var.floating_ip_count

  connection {
    host  = hcloud_server.host.0.ipv4_address
    user  = "root"
    agent = true
  }

  provisioner "remote-exec" {
    inline = [
      "ip addr add ${element(hcloud_floating_ip.floating_ip.*.ip_address, count.index)} dev eth0",
    ]
  }
}

# resource "hcloud_volume" "volume" {
#   name      = format(var.hostname_format, count.index + 1)
#   size      = 10
#   server_id = element(hcloud_server.host.*.id, count.index)
#   automount = false

#   count = var.hosts
# }

output "hostnames" {
  value = "${hcloud_server.host.*.name}"
}

output "public_ips" {
  value = "${hcloud_server.host.*.ipv4_address}"
}

output "private_ips" {
  value = "${hcloud_server.host.*.ipv4_address}"
}

output "floating_ips" {
  value = "${hcloud_floating_ip.floating_ip.*.ip_address}"
}

output "private_network_interface" {
  value = "eth0"
}
