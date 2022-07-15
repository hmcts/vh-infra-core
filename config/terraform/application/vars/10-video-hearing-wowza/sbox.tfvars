location = "uksouth"

dns_resource_group             = "vh-hearings-reform-hmcts-net-dns-zone"
dns_zone_name                  = "hearings.reform.hmcts.net"
peering_target_subscription_id = "ea3a8c1e-af9d-4108-bc86-a7e2d267f49c"

schedules = [
  {
    name      = "vm-off",
    frequency = "Day"
    interval  = 1
    run_time  = "06:00:00"
    start_vm  = false
  }
]