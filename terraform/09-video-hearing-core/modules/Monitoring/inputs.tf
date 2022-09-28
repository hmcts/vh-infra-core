# variable "apps" {
#   type = "map"
# }

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "resource_prefix" {
  description = "Resource Prefix"
  type        = string
}

variable "location" {
  description = "Resource Location"
  type        = string
}

variable "tags" {
  description = "Common Tags"
  type        = map(any)
  default     = {}
}

variable "env" {
  description = "Current Environment"
  type        = string
}

variable "action_groups" {
  description = "map of email groups"
  type = map(object({
    emails = list(string)

  }))
  default = {}
}
