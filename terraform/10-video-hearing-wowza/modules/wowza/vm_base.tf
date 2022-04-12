resource "azurerm_linux_virtual_machine" "wowza" {
  count = var.wowza_instance_count

  name = "${var.service_name}-${count.index}"

  depends_on = [
    azurerm_private_dns_a_record.wowza_storage,
    azurerm_private_dns_zone_virtual_network_link.wowza,
    azurerm_managed_disk.wowza_data
  ]

  resource_group_name = azurerm_resource_group.wowza.name
  location            = azurerm_resource_group.wowza.location

  size           = var.vm_size
  admin_username = var.admin_user
  network_interface_ids = [
    azurerm_network_interface.wowza[count.index].id,
  ]

  admin_ssh_key {
    username   = var.admin_user
    public_key = file(var.admin_ssh_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
    disk_size_gb         = 128
  }

  provision_vm_agent = true
  secret {
    certificate {
      url = var.service_certificate_kv_url
    }
    key_vault_id = var.key_vault_id
  }

  custom_data = data.template_cloudinit_config.wowza_setup.rendered

  source_image_reference {
    publisher = "wowza"
    offer     = "wowzastreamingengine"
    sku       = "linux-paid-4-8"
    version   = "latest"
  }

  plan {
    name      = "linux-paid-4-8"
    product   = "wowzastreamingengine"
    publisher = "wowza"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      var.storage_msi_client_id
    ]
  }
  tags = var.tags
}

resource "azurerm_managed_disk" "wowza_data" {
  count = var.wowza_instance_count

  name = "${var.service_name}_${count.index}-wowzadata"

  resource_group_name  = azurerm_resource_group.wowza.name
  location             = azurerm_resource_group.wowza.location
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 512
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "wowza_data" {
  count = var.wowza_instance_count

  managed_disk_id    = azurerm_managed_disk.wowza_data[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.wowza[count.index].id
  lun                = "10"
  caching            = "ReadWrite"
}