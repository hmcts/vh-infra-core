variable "resource_group_name" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "managed_identity" {
  type = list(string)
}

variable "signalr_custom_certificate_id" {
  type = string
}

variable "signalr_custom_domain" {
  type = string
}

terraform {
  required_providers {
    azapi = {
      source = "azure/azapi"
    }
  }
}

provider "azapi" {
}