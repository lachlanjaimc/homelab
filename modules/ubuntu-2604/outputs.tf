output "ubuntu-2604_password" {
  description = "Password of user 'ubuntu' on the VM"
  value       = random_password.ubuntu-2604_password.result
  sensitive   = true
}

output "ubuntu-2604_private_key" {
  description = "Private key of user 'ubuntu' on the VM"
  value     = tls_private_key.ubuntu-2604_key.private_key_pem
  sensitive = true
}

output "ubuntu-2604_public_key" {
  description = "Public key of user 'ubuntu' on the VM"
  value = tls_private_key.ubuntu-2604_key.public_key_openssh
}