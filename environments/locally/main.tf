provider "azurerm" {
  features {}
}

module "app-service-arena-game" {
  source = "../../modules/app-service-arena-game"

  prefix   = "locally-demo"
  location = "berlin"
  tags = {
    ProvisionedBy = "Terraform"
  }

  providers = {
    azurerm = azurerm
  }
}

output "arena_url" {
  value = module.app-service-arena-game.arena_url
}
