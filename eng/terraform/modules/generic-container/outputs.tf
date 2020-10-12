output "this_ips" {
  value       = azurerm_container_group.this[*].ip_address
  description = "IP address of the created container groups."
}
