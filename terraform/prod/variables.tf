# naming conventions : https://www.terraform-best-practices.com/naming

variable "az_subscription_id" {
    type = string
    default = "88902557-1215-4d72-a8b1-8174379ea946"
    description = "Subscription Id of the azure environment that terraform going to work on"
}

variable "environment_name" {
    type = string
    default = "PRD"
    description = "Three letter environment name for specifying the environment info (e.g. DEV : Development, TST : Testing)"
}

# Region info can be set explicitly for certain resource, under the variables file in modules folder.
variable "default_resource_location" {
    type = string
    default = "westeurope"
    description = "Default location info for creating resources in specified region (e.g. westeurope, westus2)"
}