variable "environment" {
    type = string
}

variable "resource_group_name" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "public_env" {
  type = number
  default = 0
}

variable "keyvaults" {
    type = map(any)
}

variable "tags" {
  type = map(any)
  default = {}
}

