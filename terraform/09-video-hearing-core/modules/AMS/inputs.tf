variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "storage_account_id" {
  type = string
}

variable "tags" {
  type    = map(any)
  default = {}
}
