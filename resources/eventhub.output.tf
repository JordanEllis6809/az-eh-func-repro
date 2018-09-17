output "eventhub-namespace" {
  value = "${azurerm_eventhub_namespace.eventhub.name}"
}

output "eventhub-testing" {
  value = "${azurerm_eventhub.testing.name}"
}

output "eventhub-testing-conneciton" {
  value = "${azurerm_eventhub_namespace.eventhub.default_primary_connection_string}"
}
