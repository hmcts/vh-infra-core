location = "uksouth"

dns_resource_group             = "vh-hearings-reform-hmcts-net-dns-zone"
dns_zone_name                  = "hearings.reform.hmcts.net"
peering_target_subscription_id = "fb084706-583f-4c9a-bdab-949aac66ba5c"

schedules = [
  {
    name      = "vm-off",
    frequency = "Day"
    interval  = 1
    run_time  = "06:00:00"
    start_vm  = false
  }
]

route_table = [
  {
    name                   = "ss_test_aks"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.72.36"
  },
  {
    name                   = "azure_control_plane"
    address_prefix         = "51.145.56.125/32"
    next_hop_type          = "Internet"
    next_hop_in_ip_address = null
  }
]