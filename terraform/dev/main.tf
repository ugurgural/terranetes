# Define that the Azure provider should be used
# and lock down the version
terraform {
  required_providers {
    azurerm = {
      version = "~> 2.0"
    }
    kubernetes = {
      version = "~> 1.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-tfstate"
    storage_account_name = "mugtfstatestorage"
    container_name       = "tfstate"
    key                  = "terraform.tfstate.dev"
  }
}

provider azurerm {
  features {}
}


# https://www.terraform.io/docs/configuration/modules.html
module "az_resource_group" {
  source    = "../modules/resource-group"
  # https://www.terraform.io/docs/configuration/functions/format.html
  rg_name    = "${var.environment_name}-tf-demo"
  # Region info can be set explicitly for certain resource, under the variables file in modules folder.
  rg_location  = var.default_resource_location
}