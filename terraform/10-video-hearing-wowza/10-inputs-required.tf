# General

variable "control_vault" {
  type = string
}

variable "project" {
  type = string
}

variable "product" {
  type = string
}

variable "builtFrom" {
  type = string
}

### The defaults need to be removed once up and running
variable "environment" {
  type = string
}

variable "activity_name" {
  type    = string
  default = "VH"
}

variable "location" {
  type = string
}

# # DNS
variable "dns_zone_name" {
  type = string
}

variable "dns_resource_group" {
  type = string
}

variable "dev_group" {
  type        = string
  default     = "dcd_videohearings"
  description = "specifies group to which permissions will be assigned when deploying the dev environment"
}

variable "workspace_to_address_space_map" {
  type = map(string)
  default = {
    prod = "10.50.11.16/28"
    stg  = "10.50.10.112/28"
    dev  = "10.100.198.64/28"
    test = "10.100.197.208/28"
    sbox = "10.100.198.32/28"
    ithc = "10.100.197.224/28"
  }
}

variable "schedules" {
  type = list(object({
    name      = string
    frequency = string
    interval  = number
    run_time  = string
    start_vm  = bool
  }))
  default     = []
  description = "List of Schedules to trigger the VM turn on and/or off."
}


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

variable "peering_target_subscription_id" {
  description = "hub network for peering subscription ID"
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


locals {
  common_tags = module.ctags.common_tags
}
#these are only used in 09-video-hearing-core however for dev purposes they remain here
variable "external_passwords" {

  type = map(string)
  default = {
    azuread--temporarypassword = "temp"
    defaultpassword            = "temp"
  }
}

module "ctags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.environment
  product     = var.product
  builtFrom   = var.builtFrom
}

variable "route_table" {
  description = "Route Table routes"
}

variable "dynatrace_tenant" {
  description = "Dynatrace Tenant"
  default     = ""
  type        = string
}