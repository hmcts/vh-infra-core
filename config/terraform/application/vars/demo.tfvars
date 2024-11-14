location                   = "uksouth"
vh_tenant_id               = "replace_vh_tenant_id"
vh_client_id               = "replace_vh_client_id"
vh_client_secret           = "replace_vh_client_secret"
signalr_custom_domain_name = "signalr.demo.platform.hmcts.net"
databases = {
  vhbookings = {
    collation                 = "SQL_Latin1_General_CP1_CI_AS"
    sku_name                  = "S3"
    backup_storage_redundancy = "Geo"
  }
  vhvideo = {
    collation                 = "SQL_Latin1_General_CP1_CI_AS"
    sku_name                  = "S4"
    backup_storage_redundancy = "Geo"
  }
  vhnotification = {
    collation                 = "SQL_Latin1_General_CP1_CI_AS"
    sku_name                  = "S0"
    backup_storage_redundancy = "Geo"
  }
}
