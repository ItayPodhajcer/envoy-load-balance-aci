provider "azurerm" {
  version = "=2.20.0"

  features {}
}

locals {
  deployment_name   = "envoylb"
  location          = "eastus"
  zone_name         = "example.com"
  nodes_record_name = "nodes"
}

# Create resource group
resource "azurerm_resource_group" "this" {
  name     = "rg-${local.deployment_name}-${local.location}"
  location = local.location
}

# Create containers virtual network resources
resource "azurerm_virtual_network" "this" {
  name                = "vnet-${local.deployment_name}-in"
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.1.0/24", "10.0.2.0/24"]
}

resource "azurerm_subnet" "internal" {
  name                 = "snet-${local.deployment_name}-in"
  resource_group_name  = azurerm_resource_group.this.name
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.this.name
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "snet-delegation-${local.deployment_name}"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "external" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  address_prefixes     = ["10.0.2.0/24"]
  virtual_network_name = azurerm_virtual_network.this.name
}

resource "azurerm_network_profile" "this" {
  name                = "np-${local.deployment_name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name

  container_network_interface {
    name = "nic-${local.deployment_name}"

    ip_configuration {
      name      = "ipc-${local.deployment_name}"
      subnet_id = azurerm_subnet.internal.id
    }
  }
}

# Create private DNS zone
resource "azurerm_private_dns_zone" "this" {
  name                = local.zone_name
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "dns-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}

# Create load balanced containers
module "generic_container" {
  source = "./modules/generic-container"

  deployment_name     = "${local.deployment_name}-node"
  resource_group_name = azurerm_resource_group.this.name
  location            = local.location
  nodes_count         = 3
  network_profile_id  = azurerm_network_profile.this.id
  image               = "mcr.microsoft.com/azuredocs/aci-helloworld"
  port                = 80
}

# Create node A DNS record
resource "azurerm_private_dns_a_record" "this" {
  name                = local.nodes_record_name
  zone_name           = local.zone_name
  resource_group_name = azurerm_resource_group.this.name
  ttl                 = 300
  records             = module.generic_container.this_ips
}

# Create envoy container
module "envoy_container" {
  source = "./modules/envoy-container"

  deployment_name     = "${local.deployment_name}-lb"
  resource_group_name = azurerm_resource_group.this.name
  location            = local.location
  network_profile_id  = azurerm_network_profile.this.id
  host_record         = "${azurerm_private_dns_a_record.this.fqdn}"
  port                = 80
}

# Create firewall
module "firewall" {
  source = "./modules/firewall"

  deployment_name     = "${local.deployment_name}"
  resource_group_name = azurerm_resource_group.this.name
  location            = local.location
  pips_count          = 1
  subnet_id           = azurerm_subnet.external.id
}

# Create firewall rules
module "netowork_rule" {
  source = "./modules/network-rule"

  deployment_name     = "${local.deployment_name}"
  resource_group_name = azurerm_resource_group.this.name
  firewall_name       = module.firewall.this_name
  port                = 80
  ip_addresses        = module.firewall.this_pips
}

module "nat_rule" {
  source = "./modules/nat-rule"

  deployment_name      = "${local.deployment_name}"
  resource_group_name  = azurerm_resource_group.this.name
  firewall_name        = module.firewall.this_name
  port                 = 80
  public_ip_addresses  = module.firewall.this_pips
  private_ip_addresses = [module.envoy_container.this_ip]
}
