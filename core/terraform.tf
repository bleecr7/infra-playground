terraform {
  required_version = ">= 1.3.0"

  cloud {
    organization = "brandon-lee-private-org"

    workspaces {
      name    = "core-services"
      project = "Personal-Website"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
