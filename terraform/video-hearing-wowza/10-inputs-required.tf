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
  type    = string
}

variable "activity_name" {
  type    = string
  default = "VH"
}

variable "location" {
  type    = string
}

variable "admin_ssh_key_path" {
  type    = string
  #default = "~/.ssh/wowza.pub"
}

variable "service_certificate_kv_url" {
  type = string
}

variable "service_certificate_thumbprint" {
  type = string
}

# variable "key_vault_id" {
#   type = string
# }

# # DNS
# variable "dns_zone_name" {
#   type = string
# }

# variable "dns_resource_group" {
#   type = string
# }

variable "dev_group" {
  type = string
  default = "dcd_videohearings"
  description = "specifies group to which permissions will be assigned when deploying the dev environment"
}

variable "workspace_to_address_space_map" {
  type = map(string)
  default = {
    prod    = "10.50.10.0/28"
    stg = "10.50.10.16/28"
   # preprod = "10.50.10.16/28"
    dev     = "10.50.10.32/28"
    demo    = "10.50.10.48/28"
    test    = "10.50.10.64/28"
    sbox    = "10.50.10.80/28"
    ithc    = "10.50.10.96/28"
  }
}

variable "workspace_to_storage_msi_map" {
  type = map(string)
  default = {
    prod    = "/subscriptions/4bb049c8-33f3-4860-91b4-9ee45375cc18/resourceGroups/vh-infra-wowza-prod/providers/Microsoft.ManagedIdentity/userAssignedIdentities/wowza-storage-prod"
    stg     = "/subscriptions/74dacd4f-a248-45bb-a2f0-af700dc4cf68/resourceGroups/vh-infra-wowza-stg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/wowza-storage-stg"
   # preprod = "/subscriptions/4bb049c8-33f3-4860-91b4-9ee45375cc18/resourceGroups/vh-infra-wowza-preprod/providers/Microsoft.ManagedIdentity/userAssignedIdentities/wowza-storage-preprod"
    dev     = "/subscriptions/867a878b-cb68-4de5-9741-361ac9e178b6/resourceGroups/vh-infra-wowza-dev/providers/Microsoft.ManagedIdentity/userAssignedIdentities/wowza-storage-dev"
    test    = "/subscriptions/3eec5bde-7feb-4566-bfb6-805df6e10b90/resourceGroups/vh-infra-wowza-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/wowza-storage-test"
    demo    = "/subscriptions/c68a4bed-4c3d-4956-af51-4ae164c1957c/resourceGroups/vh-infra-wowza-demo/providers/Microsoft.ManagedIdentity/userAssignedIdentities/wowza-storage-demo"
    sbox    = "/subscriptions/a8140a9e-f1b0-481f-a4de-09e2ee23f7ab/resourceGroups/vh-infra-wowza-sbox/providers/Microsoft.ManagedIdentity/userAssignedIdentities/wowza-storage-sbox"
    ithc    = "/subscriptions/ba71a911-e0d6-4776-a1a6-079af1df7139/resourceGroups/vh-infra-wowza-ithc/providers/Microsoft.ManagedIdentity/userAssignedIdentities/wowza-storage-ithc"
  }
}

locals {
  common_tags = module.ctags.common_tags
}

module "ctags" {
  source = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.environment
  product = var.product
  builtFrom = var.builtFrom
}



