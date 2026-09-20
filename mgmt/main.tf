terraform {
  required_providers {
    proxmox = {    
      source = "bpg/proxmox"
      version = "~> 0.112.0"
    }
  }
}

provider "proxmox" {
  insecure = true
}

resource "proxmox_user_token" "api_token" {
  comment         = "Managed by Terraform"
  expiration_date = "2033-01-01T22:00:00Z"
  token_name      = "api_token"
  user_id         = "root@pam"
}