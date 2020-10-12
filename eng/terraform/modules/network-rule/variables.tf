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

variable "ip_addresses" {
  type        = list(string)
  description = "Rule IP addresses."
}
