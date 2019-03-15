# Configure the Azure provider
provider "azurerm" { }

data "terraform_remote_state" "hackday" {
  backend = "azurerm"
  config = {
    storage_account_name = "tfdeployments"
    container_name       = "tfdeployments"
    key                  = "rackspacehackday"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    access_key = "zNl/E02gFjcTaFw14AQa1Q8xOYNDBAV2fhYnAZ4sDMGBJ0eHhfX0Asr4wfsQF9gPnIWhN7+wSvimQYhQ4UAcbQ=="
  }
}

resource "azurerm_resource_group" "slotDemo" {
    name = "slotDemoResourceGroup"
    location = "westus2"
}

resource "azurerm_app_service_plan" "slotDemo" {
    name                = "slotAppServicePlan"
    location            = "${azurerm_resource_group.slotDemo.location}"
    resource_group_name = "${azurerm_resource_group.slotDemo.name}"
    sku {
        tier = "Standard"
        size = "S1"
    }
}

resource "azurerm_app_service" "slotDemo" {
    name                = "TFHackDay2SlotAppService"
    location            = "${azurerm_resource_group.slotDemo.location}"
    resource_group_name = "${azurerm_resource_group.slotDemo.name}"
    app_service_plan_id = "${azurerm_app_service_plan.slotDemo.id}"
}

resource "azurerm_app_service_slot" "slotDemo" {
    name                = "TFHackDay2SlotAppServiceSlotOne"
    location            = "${azurerm_resource_group.slotDemo.location}"
    resource_group_name = "${azurerm_resource_group.slotDemo.name}"
    app_service_plan_id = "${azurerm_app_service_plan.slotDemo.id}"
    app_service_name    = "${azurerm_app_service.slotDemo.name}"
}