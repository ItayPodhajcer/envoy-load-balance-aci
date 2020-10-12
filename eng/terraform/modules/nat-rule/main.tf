resource "azurerm_firewall_nat_rule_collection" "this" {
  name                = "fwcol-${var.deployment_name}-nat"
  azure_firewall_name = var.firewall_name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Dnat"

  dynamic "rule" {
    for_each = var.public_ip_addresses
    iterator = ip_address
    content {
      name = "rule-${var.deployment_name}${ip_address.key + 1}-nat"

      source_addresses = [
        "*",
      ]

      destination_ports = [
        "${var.port}",
      ]

      destination_addresses = [
        "${ip_address.value}"
      ]

      translated_port = var.port

      translated_address = var.private_ip_addresses[ip_address.key]

      protocols = [
        "TCP"
      ]
    }
  }
}
