output "user_email" {
  value       = azuread_user.this.user_principal_name
  description = "The user email to be used as the user principal name"
}

output "user_password" {
  value       = random_password.password.result
  description = "The user's password"
  sensitive   = true
}

output "devops_project_url" {
  value       = format("https://dev.azure.com/%s/%s", var.github_org_name, azuredevops_project.this.name)
  description = "The DevOps project URL"
}
