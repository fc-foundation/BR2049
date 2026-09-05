resource "azurerm_resource_group" "this" {
  name     = local.names.resource_group
  location = var.location
  tags     = local.tags

  lifecycle {
    prevent_destroy = true
  }
}
