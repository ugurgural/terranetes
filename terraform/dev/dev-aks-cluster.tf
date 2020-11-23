
resource "azurerm_container_registry" "this" {
  name                     = "${lower(var.environment_name)}acrmug"
  resource_group_name      = module.az_resource_group.name
  location                 = var.default_resource_location
  sku                      = "Basic"
  admin_enabled            = false
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "${var.environment_name}-aks-cluster"
  location            = var.default_resource_location
  resource_group_name = module.az_resource_group.name
  dns_prefix          = "${var.environment_name}-aks-cluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = true
    }

    oms_agent {
      enabled = false
    }
  }
}


resource "azuread_application" "this" {
  name = "sp-aks-cluster"
}

resource "random_string" "aks_sp_password" {
  keepers = {
    env_name = var.environment_name
  }
  length           = 24
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  special          = true
  min_special      = 1
  override_special = "!@-_=+."
}

resource "random_string" "aks_sp_secret" {
  keepers = {
    env_name = var.environment_name
  }
  length           = 24
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  special          = true
  min_special      = 1
  override_special = "!@-_=+."
}

resource "azuread_service_principal" "this" {
  application_id               = azuread_application.this.application_id
  app_role_assignment_required = false
}

resource "azuread_service_principal_password" "this" {
  service_principal_id = azuread_service_principal.this.id
  value                = random_string.aks_sp_password.result
  end_date_relative    = "730h" # 1 month

  lifecycle {
    ignore_changes = [
      value,
      end_date_relative
    ]
  }
}

resource "azuread_application_password" "this" {
  application_object_id = azuread_application.this.id
  value                 = random_string.aks_sp_secret.result
  end_date_relative     = "730h" # 1 month

  lifecycle {
    ignore_changes = [
      value,
      end_date_relative
    ]
  }
}

resource "azurerm_role_assignment" "aks_sp_container_registry" {
  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPull"
  principal_id         = azuread_service_principal.this.object_id
}