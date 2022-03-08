variable "mail_domain" {
  description = "Mail domain for the generated users"
  type        = string
}

variable "azdo_organization" {
  description = "Azure DevOps organization"
  type        = string
}

variable "github_org_name" {
  description = "Name of the GitHub organization with the project"
  type        = string
}

variable "github_repo_name" {
  description = "Name of the GitHub project repository"
  type        = string
}

variable "github_personal_access_token" {
  type        = string
  description = "Github Org Personal Access Token"
}
