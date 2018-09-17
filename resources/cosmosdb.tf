resource "azurerm_cosmosdb_account" "db" {
  name                = "db-${azurerm_resource_group.resourcegroup.name}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  location            = "${azurerm_resource_group.resourcegroup.location}"
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  enable_automatic_failover = true

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    location          = "${azurerm_resource_group.resourcegroup.location}"
    failover_priority = 0
  }
}
