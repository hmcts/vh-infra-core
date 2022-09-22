# variable "environment" {}

# variable "environment_to_sku_map" {
#   type = map(any)
#   default = {
#     AAT = {
#       name     = "Standard_S1"
#       capacity = 1
#     }
#     Demo = {
#       name     = "Standard_S1"
#       capacity = 1
#     }
#     Dev = {
#       name     = "Free_F1"
#       capacity = 1
#     }
#     Preview = {
#       name     = "Free_F1"
#       capacity = 1
#     }
#     Sandbox = {
#       name     = "Standard_S1"
#       capacity = 1
#     }
#     Test1 = {
#       name     = "Free_F1"
#       capacity = 1
#     }
#     Test2 = {
#       name     = "Free_F1"
#       capacity = 1
#     }
#     PreProd = {
#       name     = "Standard_S1"
#       capacity = 1
#     }
#     Prod = {
#       name     = "Standard_S1"
#       capacity = 1
#     }
#   }
# }

locals {
  environment = var.environment
  # sku = lookup(var.environment_to_sku_map, var.environment, {
  #   name     = "Standard_S1"
  #   capacity = 1
  # })

  sku_name = "Premium_P1"

  sku_type = "Premium"

  sku_size = "P1"

  signalr_cd_name = "" # needed

  custom_cert_id = "" # needed

  signalr_custom_domain = "" # needs a conditional
}
