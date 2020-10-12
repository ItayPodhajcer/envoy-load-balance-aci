locals {
  config_file_path = "/etc/proxy.yaml"
  envoy_config = templatefile("${path.module}/config.tmpl", {
    host_record = var.host_record
  })
  echo_config_cmd = "echo '${local.envoy_config}' > ${local.config_file_path}"
  envoy_cmd       = "/usr/local/bin/envoy -c ${local.config_file_path}"
}

# Create node container resource
resource "azurerm_container_group" "this" {
  name                = "aci-${var.deployment_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "private"
  network_profile_id  = var.network_profile_id
  os_type             = "Linux"

  container {
    name   = var.deployment_name
    image  = "envoyproxy/envoy:v1.16-latest"
    cpu    = "0.5"
    memory = "1.5"
    commands = [
      "sh",
      "-c",
      "${local.echo_config_cmd} && ${local.envoy_cmd}"
    ]

    ports {
      port     = var.port
      protocol = "TCP"
    }
  }
}
