terraform {
  required_version = "> 0.12.26"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.60"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2"
    }
  }
}
