resource "azurerm_public_ip" "pips" {
  count               = var.pips_count
  name                = "pip-${var.deployment_name}${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "this" {
  name                = "fw-${var.deployment_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "ip_configuration" {
    for_each = azurerm_public_ip.pips
    iterator = pip
    content {
      name                 = "ipconfig-${var.deployment_name}${pip.key}"
      subnet_id            = pip.key == 0 ? var.subnet_id : null
      public_ip_address_id = pip.value.id
    }
  }
}
