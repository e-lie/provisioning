## Ansible mirroring hosts section
# Using https://github.com/nbering/terraform-provider-ansible/ to be installed manually (third party provider)
# Copy binary to ~/.terraform.d/plugins/

variable "node_count" {}

variable "public_ips" {
  type = list
}

variable "domains" {
  type = list
}


variable "floating_ips" {
  type = list
}

# variable "vpn_ips" {
#   type = list
# }

# variable "vpn_interface" {
#   type = string
# }

# variable "etcd_endpoints" {
#   type = list
# }

# variable "overlay_interface" {
#   default = "weave"
# }

# variable "overlay_cidr" {
#   default = "10.96.0.0/16"
# }

terraform {
  required_providers {
    ansible = {
      source = "nbering/ansible"
      version = "1.0.4"
    }
  }
}

provider "ansible" {
  # Configuration options
}

resource "ansible_host" "kube_nodes" {
  count = var.node_count
  inventory_hostname = element(var.domains, count.index)
  groups = ["all", "kube_nodes"]
  vars = {
    ansible_host = element(var.public_ips, count.index)
    ansible_user = "root"
  }
}

resource "ansible_host" "floating_ips" {
  count = length(var.floating_ips)
  inventory_hostname = element(var.floating_ips, count.index)
  groups = ["all", "floating_ips"]
  vars = {
    ansible_host = element(var.floating_ips, count.index)
  }
}

resource "ansible_group" "kube-nodes" {
  inventory_group_name = "kube_nodes"
  vars = {
    ansible_python_interpreter = "/usr/bin/python3"
  }
}

