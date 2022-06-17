location                       = "uksouth"
admin_ssh_key_path             = "/home/vsts/work/_temp/wowza-ssh-public-key.pub"
service_certificate_thumbprint = "0EFFF7E276BA76414FE456574A491AAE93008D2F"
service_certificate_kv_url     = "https://vh-infra-core-stg.vault.azure.net/secrets/wildcard-hearings-reform-hmcts-net/29fa085a1b1940db82d3fa8faf49dd78"


dns_resource_group             = "vh-hearings-reform-hmcts-net-dns-zone"
dns_zone_name                  = "hearings.reform.hmcts.net"
peering_target_subscription_id = "fb084706-583f-4c9a-bdab-949aac66ba5c"


schedules = [
  {
    name      = "vm-on",
    frequency = "Day"
    interval  = 1
    run_time  = "06:00:00"
    start_vm  = true
  },
  {
    name      = "vm-off",
    frequency = "Day"
    interval  = 1
    run_time  = "18:00:00"
    start_vm  = false
  }
]