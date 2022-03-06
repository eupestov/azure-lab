terraform {
  required_version = "~> 1.1.7"

  # The configuration for this backend will be filled in by Terragrunt
  # backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.97.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }

    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 0.1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "azuredevops" {}

locals {
  lab_name = random_string.name.result
}

resource "random_string" "name" {
  length  = 16
  special = false
}

resource "random_password" "password" {
  length  = 16
  special = false
}

##
# AzureAD user
##
resource "azuread_user" "this" {
  user_principal_name = format("%s@%s", local.lab_name, var.mail_domain)
  display_name        = local.lab_name
  password            = random_password.password.result
}

##
# Azure DevOps project and pipeline
##
resource "azuredevops_project" "this" {
  name            = format("lab-%s", local.lab_name)
  version_control = "Git"
}

resource "azuredevops_serviceendpoint_github" "github_serviceendpoint" {
  project_id            = azuredevops_project.this.id
  service_endpoint_name = "GitHub"

  auth_personal {
    personal_access_token = var.github_personal_access_token
  }
}

resource "azuredevops_build_definition" "tf" {
  project_id          =  azuredevops_project.this.id
  name                =  "Sample Build"

  ci_trigger {
    use_yaml  =   true
  }

  repository {
    repo_type             =   "GitHub"
    repo_id               =   join("/", [var.github_org_name, var.github_repo_name])
    branch_name           =   "main"
    yml_path              =   "azure-pipelines.yml"
    service_connection_id =   azuredevops_serviceendpoint_github.github_serviceendpoint.id
  }
}

data "azurerm_subscription" "primary" {}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "default" {
  name = "default"
}

resource "azurerm_key_vault" "this" {
  name                        = format("lab-%s", local.lab_name)
  location                    = data.azurerm_resource_group.default.location
  resource_group_name         = data.azurerm_resource_group.default.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

##
# Azure IAM
#
# TODO: narrow the permissions
##
resource "azurerm_role_definition" "this" {
  name        = format("role-lab-%s", local.lab_name)
  scope       = data.azurerm_subscription.primary.id

  permissions {
    actions     = ["*"]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}

resource "azurerm_role_assignment" "this" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.this.name
  principal_id         = azuread_user.this.id
}