# Create node container resource
resource "azurerm_container_group" "this" {
  count               = var.nodes_count
  name                = "aci-${var.deployment_name}${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "private"
  network_profile_id  = var.network_profile_id
  os_type             = "Linux"

  container {
    name   = "${var.deployment_name}${count.index + 1}"
    image  = var.image
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = var.port
      protocol = "TCP"
    }
  }
}
