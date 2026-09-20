terraform {
  required_providers {
    proxmox = {    
      source = "bpg/proxmox"
      version = "~> 0.112.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://pve:8006"
  insecure = true

  ssh {
    agent = true
  }
}

resource "proxmox_virtual_environment_user" "terraform_admin" {
  comment  = "Managed by Terraform"
  password = var.terraform_admin_password
  user_id  = "terraform_admin@pve"
}

resource "proxmox_acl" "acl_terraform_admin" {
  user_id = proxmox_virtual_environment_user.terraform_admin.id
  role_id   = "Administrator"
  path      = "/"
  propagate = true
}

resource "proxmox_user_token" "api_token" {
  comment               = "Managed by Terraform"
  expiration_date       = "2033-01-01T22:00:00Z"
  token_name            = "api_token"
  user_id               = proxmox_virtual_environment_user.terraform_admin.id
  privileges_separation = false
}