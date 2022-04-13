variable "resource_group_name" {
  type = string
}
variable "environment" {
  type = string
}

variable "redis_cache_standard_required" {
  default = "false"
}
variable "location" {
  type = string
}