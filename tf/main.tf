provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "safe-deploy-rg" {
  name     = "safe-deploy-rg-${var.environment}"
}

resource "azurerm_storage_account" "safe_deploy_storage" {
  name                     = "safestorage${var.environment}"
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

resource "azurerm_service_plan" "safe_deploy_service_plan" {
  name                = "sd-service-plan-${var.environment}"
  location            = data.azurerm_resource_group.safe-deploy-rg.location
  resource_group_name = data.azurerm_resource_group.safe-deploy-rg.name
  os_type                    = "Linux"
  sku_name = "Y1"
}

resource "azurerm_linux_function_app" "visitors-app" {
  name                = "safe-deploy-function-app-${var.environment}"
  resource_group_name = data.azurerm_resource_group.safe-deploy-rg.name
  location            = data.azurerm_resource_group.safe-deploy-rg.location

  storage_account_name       = azurerm_storage_account.safe_deploy_storage.name
  storage_account_access_key = azurerm_storage_account.safe_deploy_storage.primary_access_key
  service_plan_id            = azurerm_service_plan.safe_deploy_service_plan.id

  https_only      = true
  #zip_deploy_file = "../../api/visitors-functions.zip"
  site_config {
    application_stack {
      node_version = 18.0
    }
  }

  app_settings = {
    STORAGE_ACCOUNT_NAME = "safestorage${var.environment}"
    STORAGE_CONTAINER_NAME       = "webcontent"
    STORAGE_BLOB_NAME            = "index.html"
  }
}