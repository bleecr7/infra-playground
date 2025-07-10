terraform {
  required_version = ">= 1.3.0"

  cloud {
    organization = "brandon-lee-private-org"

    workspaces {
      name    = "IaaS"
      project = "Personal-Website"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}
