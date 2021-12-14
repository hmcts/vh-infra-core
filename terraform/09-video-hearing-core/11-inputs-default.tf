# Uncomment defaults to run locally/supply values
variable "location" {
  type = string
}

variable "build_agent_vnet" {
  type    = list(string)
  default = []
}

variable "vh_tenant_id" {
  type    = string
  default = ""
}

variable "vh_client_id" {
  type    = string
  default = ""
}

variable "vh_client_secret" {
  type    = string
  #default = ""
}

variable "dns_tenant_id" {
  type    = string
  default = ""
}

variable "dns_client_id" {
  type    = string
  default = ""
}

variable "dns_client_secret" {
  type    = string
  #default = ""
}

variable "dns_subscription_id" {
  type    = string
  default = ""
}
