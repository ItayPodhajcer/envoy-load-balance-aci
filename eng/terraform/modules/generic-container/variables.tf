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

variable "nodes_count" {
  type        = number
  description = "Number of nodes."
}

variable "network_profile_id" {
  type        = string
  description = "Network profile ID."
}

variable "image" {
  type        = string
  description = "Name of container image."
}

variable "port" {
  type        = number
  description = "Container port number."
}
