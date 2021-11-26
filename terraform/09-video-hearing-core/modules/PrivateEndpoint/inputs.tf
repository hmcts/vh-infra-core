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
    id = list(string)
  }))
  description = "VH Core Infra resources"
  default     = {}
}
