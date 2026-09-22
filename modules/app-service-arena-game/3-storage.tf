# ---------------------------------------------------------------------------
# Storage Account - contains a File Share where the leaderboard is persisted
# ---------------------------------------------------------------------------
resource "azurerm_storage_account" "arena" {
  name                     = "${replace(var.prefix, "-", "")}sa"
  resource_group_name      = azurerm_resource_group.arena.name
  location                 = azurerm_resource_group.arena.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# ---------------------------------------------------------------------------
# File Share - mounted into the App Service and hosts the leaderboard
# ---------------------------------------------------------------------------
resource "azurerm_storage_share" "arena" {
  name               = "leaderboard"
  storage_account_id = azurerm_storage_account.arena.id
  quota              = 1
}
