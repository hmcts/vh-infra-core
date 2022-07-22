variable "resource_group_name" {
  type = string
}

variable "resource_prefix" {
  type = string
}
variable "key_vault_id" {
  type = string
}
variable "keyvault_name" {
  type = string
}
variable "public_env" {
  type    = number
  default = 0
}

variable "databases" {
  type = map(any)
}

variable "queues" {
  type = map(any)
}

variable "location" {
  type = string
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "environment" {}