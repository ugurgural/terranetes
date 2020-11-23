# naming conventions : https://www.terraform-best-practices.com/naming

output "name" {
    value = azurerm_resource_group.this.name
    description = "Name of the resource group"
    # Keep sensitive flag true for important values
    # https://www.terraform.io/docs/configuration/outputs.html#sensitive-suppressing-values-in-cli-output
    sensitive   = false
}

output "location" {
    value = azurerm_resource_group.this.location
    description = "Location of the resource group"
    sensitive   = false
}