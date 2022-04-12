variable "resource_group_name" {
  type = string
}

variable "resource_prefix" {
  type = string
}

# variable "delegated_networks" {
#   type = map(any)
# }

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