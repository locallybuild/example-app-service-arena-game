# ---------------------------------------------------------------------------
# Resource Group - which contains the deployed resources
# ---------------------------------------------------------------------------
resource "azurerm_resource_group" "arena" {
  name     = "${var.prefix}-resources"
  location = var.location
  tags     = var.tags
}
