# variable "apps" {
#   type = "map"
# }

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
  type = map(any)
  default = {}
}
