provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "safe-deploy-rg" {
  name     = "safe-deploy-rg-${var.environment}"
}

resource "azurerm_storage_account" "safe_deploy_storage" {
  name                     = "safedeploystorage-${var.environment}"
  resource_group_name      = data.azurerm_resource_group.safe-deploy-rg.name
  location                 = data.azurerm_resource_group.safe-deploy-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "web_content" {
  name                  = "webcontent"
  storage_account_name  = azurerm_storage_account.safe_deploy_storage.name
  container_access_type = "private"
}

resource "azurerm_service_plan" "safe_deploy_function_plan" {
  name                = "safe-deploy-functions-${var.environment}"
  location            = data.azurerm_resource_group.safe-deploy-rg.location
  resource_group_name = data.azurerm_resource_group.safe-deploy-rg.name
  os_type                    = "Linux"
  sku_name = "Y1"
}