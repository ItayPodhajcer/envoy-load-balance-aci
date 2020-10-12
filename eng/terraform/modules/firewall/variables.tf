variable "deployment_name" {
  type        = string
  description = "Deployment name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Private network location."
}

variable "pips_count" {
  type        = number
  description = "Number of public IPs to generate"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to host the firewall"
}
