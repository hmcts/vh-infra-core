locals {
  cvp_environment              = var.environment == "prod" ? var.environment : "stg"
  cvp_container_name           = "recordings"
  cvp_storage_account_name     = "cvprecordings${local.cvp_environment}sa"
  cvp_storage_account_endpoint = "https://${local.cvp_storage_account_name}.blob.core.windows.net/"
  cvp_resource_group_name      = "cvp-recordings-${local.cvp_environment}-rg"
}

data "azurerm_storage_account" "cvp" {
  provider            = azurerm.cvp
  name                = local.cvp_storage_account_name
  resource_group_name = local.cvp_resource_group_name
}

module "KeyVault_Cvp_Secrets" {
  source         = "./modules/KeyVaults/Secrets"
  key_vault_id   = module.KeyVaults.keyvault_id
  key_vault_name = module.KeyVaults.keyvault_name

  tags = local.common_tags
  secrets = [
    {
      name         = "CvpConfiguration--StorageAccountName"
      value        = local.cvp_storage_account_name
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "CvpConfiguration--StorageAccountKey"
      value        = data.azurerm_storage_account.cvp.primary_access_key
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "CvpConfiguration--StorageContainerName"
      value        = local.cvp_container_name
      tags         = local.common_tags
      content_type = "secret"
    },
    {
      name         = "CvpConfiguration--StorageEndpoint"
      value        = local.cvp_storage_account_endpoint
      tags         = local.common_tags
      content_type = "secret"
    }
  ]

  depends_on = [
    module.KeyVaults
  ]
}
