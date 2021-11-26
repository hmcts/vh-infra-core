variable "environment" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
    type = string
}

variable "subnet_name" {
    type = string
}

variable "resources" {
  type = map(object({
    id = list(string)
  }))
  description = "VH Core Infra resources"
  default     = {}
}
