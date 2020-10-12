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

variable "network_profile_id" {
  type        = string
  description = "Network profile ID."
}

variable "port" {
  type        = number
  description = "Container port number."
}

variable "host_record" {
  type        = string
  description = "DNS A record holding the list of load balanced nodes."
}
