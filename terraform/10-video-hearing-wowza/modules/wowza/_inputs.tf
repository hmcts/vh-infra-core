variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "service_name" {
  type = string
}

variable "address_space" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_F8s_v2"
}

variable "admin_user" {
  type    = string
  default = "wowza"
}

variable "admin_ssh_key_path" {
  type = string
  #default = "~/.ssh/wowza.pub"
}

variable "os_disk_type" {
  type    = string
  default = "Standard_LRS"
}

variable "key_vault_id" {
  type = string
}

variable "cloud_init_file" {
  description = "The location of the cloud init configuration file."
  type        = string
  default     = "./cloudconfig.tpl"
}

variable "wowza_instance_count" {
  type    = number
  default = 2
}

variable "storage_msi_client_id" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

# variable "schedule_actions"{
#  description = "The time and action required for the Wowza VM automation"
#  type = map(string)
#}

variable "private_dns_zone_group_name" {}

variable "private_dns_zone_group" {}

#variable "hearings_dns_zone" {}

# Networking Client Details
variable "network_client_id" {
  description = "Client ID of the GlobalNetworkPeering SP"
  type        = string
}
variable "network_client_secret" {
  description = "Client Secret of the GlobalNetworkPeering SP"
  type        = string
  sensitive   = true
}
variable "network_tenant_id" {
  description = "Client Tenant ID of the GlobalNetworkPeering SP"
  type        = string
}

# Automation start/stop variables
variable "runbook_name" {
  description = "Name of runbook file to be used to schedule VM start / stop"
  type        = string
  default     = "wowza-vm-runbook.ps1"
}

variable "start_time" {
  description = "The time that the Wowza VMs should restart"
  type        = string
  default     = "06:00:00"
}

variable "stop_time" {
  description = "The time that the Wowza VMs should stop"
  type        = string
  default     = "22:00:00"
}

## Automation Accounts
variable "schedules" {
  default = []
}