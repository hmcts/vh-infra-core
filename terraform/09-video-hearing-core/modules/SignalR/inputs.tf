variable "resource_group_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "managed_identities" {
  type = list(string)
}

variable "signalr_custom_domain" {
  type = string
}

variable "key_vault_cert_name" {
  type = string
}

variable "key_vault_uri" {
  type = string
}