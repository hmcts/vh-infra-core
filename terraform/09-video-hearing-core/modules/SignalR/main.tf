# resource "azurerm_signalr_service" "vh" {
#   name                = var.resource_prefix
#   resource_group_name = var.resource_group_name
#   location            = var.location

#   sku {
#     name     = "Premium_P1"
#     capacity = 1
#   }
#   tags = var.tags
# }

resource "azurerm_resource_group_template_deployment" "ARMdeploy-signalR-MI" {
  name                = var.resource_prefix
  resource_group_name = var.resource_group_name

  # "Incremental" ADDS the resource to already existing resources. "Complete" destroys all other resources and creates the new one
  deployment_mode = "Incremental"

  # the parameters below can be found near the top of the ARM file
  parameters_content = jsonencode({
    "tw_test_signalr_name" = {
      value = local.signalr_name
    },
    "my_location" = {
      value = var.location
    },
    "tags" = {
      value = var.tags
    },
    "sku_name" = {
      value = locals.sku_name
    },
    "sku_type" = {
      value = locals.sku_type
    },
    "sku_size" = {
      value = locals.sku_size
    },
    "userAssigned_identity" = {
      value = azurerm_user_assigned_identity.signalr-managed-id.id # need this info
    },
    "signalr_cd_name" = {
      value = var.resource_prefix
    },
    "signalr_custom_certificate_id" = {
      value = locals.custom_cert_id
    },
    "signalr_custom_domain" = {
      value = locals.signalr_custom_domain
    }
  })
  # the actual ARM template file we will use
  template_content = file("signalr-template.json")
}