
resource "azurerm_storage_account" "filestorage" {
  name                = "${lower(var.environment_name)}filestoragemug"
  resource_group_name = module.az_resource_group.name
  location            = var.default_resource_location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  access_tier               = "Hot"
  allow_blob_public_access  = true
}

resource "azurerm_storage_container" "this" {
  name                  = "storagecontainer"
  storage_account_name  = azurerm_storage_account.filestorage.name
  container_access_type = "blob"
}