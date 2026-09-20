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
}

resource "proxmox_virtual_environment_user" "terraform_admin" {
  comment  = "Managed by Terraform"
  password = var.terraform_admin_password
  user_id  = "terraform_admin@pve"
}

resource "proxmox_user_token" "api_token" {
  comment         = "Managed by Terraform"
  expiration_date = "2033-01-01T22:00:00Z"
  token_name      = "api_token"
  user_id         = proxmox_virtual_environment_user.terraform_admin.id
}