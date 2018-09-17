resource "azurerm_app_service_plan" "plan" {
  name = "funcapp-plan-${azurerm_resource_group.resourcegroup.name}"
  location = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  kind = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = "funcappstrgtest"
  resource_group_name      = "${azurerm_resource_group.resourcegroup.name}"
  location                 = "${azurerm_resource_group.resourcegroup.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_function_app" "functionapp" {
  name = "funcapp-${azurerm_resource_group.resourcegroup.name}"
  location = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  app_service_plan_id = "${azurerm_app_service_plan.plan.id}"
  storage_connection_string = "${azurerm_storage_account.storage.primary_connection_string}"

  app_settings {
    "EH_NAMESPACE" = "${azurerm_eventhub_namespace.eventhub.name}"
    "EH_CONNECTIONSTRING" = "${azurerm_eventhub_namespace.eventhub.default_primary_connection_string}"
    "EH_NAME" = "${azurerm_eventhub.testing.name}"
    "DB_CONNECTIONSTRING" = "AccountEndpoint=${azurerm_cosmosdb_account.db.endpoint};AccountKey=${azurerm_cosmosdb_account.db.primary_master_key};"
    "DB_ENDPOINT" = "${azurerm_cosmosdb_account.db.endpoint}"
    "DB_KEY" = "${azurerm_cosmosdb_account.db.primary_master_key}"
    "DB_NAME" = "db"
    "DB_COLLECTION" = "Testing"
  }
}
