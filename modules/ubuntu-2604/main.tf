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

resource "proxmox_virtual_environment_vm" "ubuntu-2604" {
  name = var.vm_name
  description = "Managed by Terraform"
  tags = ["ubuntu-2604", "terraform"]
  
  node_name = "pve"
  vm_id     = var.vm_id

  timeout_create = 1800
  timeout_clone  = 1800

  agent {
    enabled = true
  }

  cpu {
    cores = var.cpu_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.mem_dedicated
    floating  = var.mem_floating
  }

  disk {
    datastore_id = "disks"
    import_from  = proxmox_virtual_environment_download_file.ubuntu-2604.id
    interface    = "scsi0"
    size         = var.vm_disk_size
  }

  initialization {
    datastore_id = "disks"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }

  network_device {
    bridge = var.vm_bridge
    vlan_id = var.vlan_id
  }

  operating_system {
    type = "l26"
  }

  tpm_state {
    version = "v2.0"
  }

  serial_device {}
}

resource "proxmox_virtual_environment_download_file" "ubuntu-2604" {
  content_type = "import"
  datastore_id = "local"
  node_name = "pve"
  url = "https://cloud-images.ubuntu.com/releases/resolute/release/ubuntu-26.04-server-cloudimg-amd64.img"
  file_name = "ubuntu-26.04-server-cloudimg-amd64.qcow2"
}

resource "random_password" "ubuntu-2604_password" {
  length  = 14
  special = false
}

resource "tls_private_key" "ubuntu-2604_key" {
  algorithm = "ED25519"
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: ${var.vm_name}
    timezone: America/Denver
    users:
      - default
      - name: ubuntu
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys:
          - ${trimspace(tls_private_key.ubuntu-2604_key.public_key_openssh)}
        sudo: ALL=(ALL) NOPASSWD:ALL
    package_update: true
    packages:
      - qemu-guest-agent
      - net-tools
      - curl
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "user-data-cloud-config.yaml"
  }
}