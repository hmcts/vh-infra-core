# Create an Automation Account that uses a user-assigned Managed Identity
# This is currently (Jan 2022) done using an ARM template

resource "azurerm_resource_group_template_deployment" "wowza-automation-acct" {
  name                = "wowza-automation-acct-${var.environment}"
  resource_group_name = azurerm_resource_group.wowza.name

  # "Incremental" ADDS the resource to already existing resources. "Complete" destroys all other resources and creates the new one
  deployment_mode = "Incremental"

  # the parameters below can be found near the top of the ARM file
  parameters_content = jsonencode({
    "automationAccount_name" = {
      value = "wowza-automation-acct-${var.environment}"
    },
    "my_location" = {
      value = var.location
    },
    "userAssigned_identity" = {
      value = azurerm_user_assigned_identity.wowza-automation-account-mi.id
    }
  })
  # the actual ARM template file we will use
  template_content = file("./VM-Automation-Files/ARM-user-assigned-mi.json")

  tags = var.tags

}