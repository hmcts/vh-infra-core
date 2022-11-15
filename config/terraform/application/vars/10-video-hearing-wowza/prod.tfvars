location = "uksouth"

dns_resource_group = "vh-hearings-reform-hmcts-net-dns-zone"
dns_zone_name      = "hearings.reform.hmcts.net"

peering_target_subscription_id = "0978315c-75fe-4ada-9d11-1eb5e0e0b214"

schedules = [
  {
    name      = "vm-on",
    frequency = "Day"
    interval  = 1
    run_time  = "06:00:00"
    start_vm  = true
  }
]
route_table = [
  {
    name                   = "azure_control_plane"
    address_prefix         = "51.145.56.125/32"
    next_hop_type          = "Internet"
    next_hop_in_ip_address = null
  },
  {
    name                   = "ss_prod_aks"
    address_prefix         = "10.144.0.0/18"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.8.36"
  },
  {
    name                   = "soc-prod-vnet"
    address_prefix         = "10.146.0.0/21"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.8.36"
  }
]
dynatrace_tenant = "ebe20728"