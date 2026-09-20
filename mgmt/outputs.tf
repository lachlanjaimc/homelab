output "api_token_id" {
  sensitive   = true
  description = "API token ID of the PVE instance"
  value       = proxmox_user_token.api_token.id
}

output "api_token_value" {
  sensitive   = true
  description = "API token value of the PVE instance"
  value       = proxmox_user_token.api_token.value
}