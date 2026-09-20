output "api_token" {
  sensitive   = true
  description = "API token of the PVE instance"
  value       = proxmox_user_token.api_token.value
}