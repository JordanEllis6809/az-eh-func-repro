output "cosmos-db-account-name" {
  value = "${azurerm_cosmosdb_account.db.name}"
}

output "cosmos-db-name" {
  value = "db"
}

output "cosmos-db-collection" {
  value = "Testing"
}

output "cosmos-db-endpoint" {
  value = "${azurerm_cosmosdb_account.db.endpoint}"
}

output "cosmos-db-key" {
  value = "${azurerm_cosmosdb_account.db.primary_master_key}"
}

output "cosmos-db-connection" {
  value = "AccountEndpoint=${azurerm_cosmosdb_account.db.endpoint};AccountKey=${azurerm_cosmosdb_account.db.primary_master_key};"
}

output "cosmos-db-resourcegroup" {
  value = "${azurerm_cosmosdb_account.db.resource_group_name}"
}
