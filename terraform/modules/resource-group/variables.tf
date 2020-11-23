# naming conventions : https://www.terraform-best-practices.com/naming

variable "rg_name" {
    type = string
    description = "Name of the resource group in BuildingMinds azure resources naming convention (e.g. DEV-bmcl-api-configs)"
}

variable "rg_location" {
    type = string
    description = "Default location info for creating resources in specified region (e.g. westeurope, westus2)"
}