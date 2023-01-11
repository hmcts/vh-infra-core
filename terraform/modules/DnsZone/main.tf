resource "azurerm_dns_a_record" "vh" {
  for_each = var.a

  name                = each.value.name
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  records             = [each.value.value]
}

resource "azurerm_dns_cname_record" "vh" {
  for_each = var.cnames

  name                = each.value.name
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  record              = each.value.value
}
