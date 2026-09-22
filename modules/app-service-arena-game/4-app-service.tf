locals {
  # Specifies the path at which the leaderboard is mounted within the container.
  leaderboard_mount_path = "/mnt/leaderboard"
}

# ---------------------------------------------------------------------------
# App Service Plan - houses the App Service with the custom container.
# ---------------------------------------------------------------------------
resource "azurerm_service_plan" "arena" {
  name                = "${var.prefix}-plan"
  resource_group_name = azurerm_resource_group.arena.name
  location            = azurerm_resource_group.arena.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# ---------------------------------------------------------------------------
# Linux App Service - provision the custom container from the container registry.
#
# The Arena Game serves both HTTP and WebSockets over the same port.
# ---------------------------------------------------------------------------
resource "azurerm_linux_web_app" "arena" {
  name                = "${var.prefix}-arena"
  resource_group_name = azurerm_resource_group.arena.name
  location            = azurerm_service_plan.arena.location
  service_plan_id     = azurerm_service_plan.arena.id

  site_config {
    application_stack {
      docker_image_name        = local.image_name
      docker_registry_url      = "https://${azurerm_container_registry.arena.login_server}"
      docker_registry_username = azurerm_container_registry.arena.admin_username
      docker_registry_password = azurerm_container_registry.arena.admin_password
    }
  }

  app_settings = {
    # Specify which port the application is listening on
    "WEBSITES_PORT" = "3000"

    # Specify where the Leaderboard file should be saved/loaded from (the File Share)
    "LEADERBOARD_FILE" = "${local.leaderboard_mount_path}/leaderboard.json"
  }

  # Mount the File Share into the Container at this path
  storage_account {
    name         = "leaderboard"
    type         = "AzureFiles"
    account_name = azurerm_storage_account.arena.name
    share_name   = azurerm_storage_share.arena.name
    access_key   = azurerm_storage_account.arena.primary_access_key
    mount_path   = local.leaderboard_mount_path
  }

  depends_on = [terraform_data.import_image]
}
