resource "azurerm_firewall_network_rule_collection" "this" {
  name                = "fwcol-${var.deployment_name}-network"
  azure_firewall_name = var.firewall_name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Allow"

  rule {
    name = "rule-${var.deployment_name}-network"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "${var.port}",
    ]

    destination_addresses = var.ip_addresses

    protocols = [
      "TCP"
    ]
  }
}
