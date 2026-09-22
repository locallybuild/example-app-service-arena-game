output "arena_url" {
  description = "The web app's default hostname (…furnace.locally)."
  value       = "https://${azurerm_linux_web_app.arena.default_hostname}"
}

output "resource_group" {
  value = azurerm_resource_group.arena.name
}

output "acr_login_server" {
  description = "ACR login server the image is imported into and pulled from (<name>.dockhand.locally:5667)."
  value       = azurerm_container_registry.arena.login_server
}

output "leaderboard_storage_account" {
  description = "Storage account backing the persistent leaderboard file share."
  value       = azurerm_storage_account.arena.name
}
