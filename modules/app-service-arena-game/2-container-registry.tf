locals {
  source_image_version = "v1"
  source_image         = "docker.io/tombuildsstuff/web-arena-game:${local.source_image_version}"
  image_name           = "web-arena-game:${local.source_image_version}"
}

# ---------------------------------------------------------------------------
# Container Registry - for storing Container Images within Locally
#
# This allows us to store the image within Locally, which isn't strictly
# necessary, but does allow us to demonstrate how you would do this, and
# how you can import an existing image into it.
# ---------------------------------------------------------------------------
resource "azurerm_container_registry" "arena" {
  name                = "${replace(var.prefix, "-", "")}acr"
  resource_group_name = azurerm_resource_group.arena.name
  location            = azurerm_resource_group.arena.location
  sku                 = "Basic"
  admin_enabled       = true
}

# ---------------------------------------------------------------------------
# Import the arena game image from Docker Hub into the Locally ACR.
#
# Use the Azure CLI to import an image from Docker Hub into the Container Registry
# that we've created within Locally.
# ---------------------------------------------------------------------------
resource "terraform_data" "import_image" {
  triggers_replace = [
    local.source_image_version,
    local.source_image,
    azurerm_container_registry.arena.login_server,
  ]

  provisioner "local-exec" {
    command = "az acr import --name ${azurerm_container_registry.arena.name} --source ${local.source_image} --image ${local.image_name} --force"
  }
}
