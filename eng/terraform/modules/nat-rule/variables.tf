variable "deployment_name" {
  type        = string
  description = "Deployment name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "firewall_name" {
  type        = string
  description = "Firewall name."
}

variable "port" {
  type        = number
  description = "Rule port."
}

variable "public_ip_addresses" {
  type        = list(string)
  description = "Rule public IP addresses."
}

variable "private_ip_addresses" {
  type        = list(string)
  description = "Rule private IP addresses."
}
