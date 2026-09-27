terraform {
  required_providers {
    proxmox = {    
      source = "bpg/proxmox"
      version = "~> 0.112.0"
    }
  }
}

data "terraform_remote_state" "mgmt_state" {
  backend = "local"

  config = {
    path = "../mgmt/terraform.tfstate"
  }
}

provider "proxmox" {
  endpoint = "https://pve:8006"
  insecure = true
  api_token = "${data.terraform_remote_state.mgmt_state.outputs.api_token_value}"

  ssh {
    agent = true
    username = "root"
  }
}

module "jenkins-node" {
  source = "../modules/ubuntu-2604"

  providers = {
    proxmox = proxmox
  }

  vm_name = "jenkins-node"
  vm_id   = 300
  cpu_cores = 2
  mem_dedicated = 2048
  mem_floating = 2048
  vm_bridge = "vmbr0"
  vlan_id = 30
  vm_disk_size = 20
}