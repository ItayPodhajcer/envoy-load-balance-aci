output "this_name" {
  value       = azurerm_firewall.this.name
  description = "Created firewall name."
}

output "this_pips" {
  value       = azurerm_public_ip.pips[*].ip_address
  description = "Created public IPs."
}
