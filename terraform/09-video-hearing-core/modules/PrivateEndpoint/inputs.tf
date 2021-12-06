variable "environment" {
  type = string
}

variable "tags" {
  type = map(any)
  default = {}
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
    type = string
}

variable "resources" {
  type = map(object({
    resource_id   = string
    resource_name = string
    resource_type = string
  }))
  description = "VH Core Infra resources"
  default     = {}
}

variable "app_keyvaults_map" {
    type = map(any)
}