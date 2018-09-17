output "function-app-name" {
  value = "${azurerm_function_app.functionapp.name}"
}

output "function-app-resourcegroup" {
  value = "${azurerm_function_app.functionapp.resource_group_name}"
}
