

resource "azurerm_monitor_action_group" "this" {
  for_each = var.action_groups

  name                = "VhCriticalAlertsAction-${each.key}-${var.env}"
  resource_group_name = var.resource_group_name
  short_name          = "vhp1action"

  dynamic "email_receiver" {
    for_each = each.value.emails
    content {
      name          = split(email_receiver.value, "@")[0]
      email_address = email_receiver.value
    }
  }
  tags = var.tags
}
