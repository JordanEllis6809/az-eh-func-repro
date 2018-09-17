resource "azurerm_eventhub_namespace" "eventhub" {
  name                = "ehn-${azurerm_resource_group.resourcegroup.name}"
  location            = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"

  sku      = "Standard"
  capacity = 2
}

resource "azurerm_eventhub" "testing" {
  name                = "testing"
  namespace_name      = "${azurerm_eventhub_namespace.eventhub.name}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"

  partition_count   = 2
  message_retention = 1
}
