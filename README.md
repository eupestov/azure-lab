# azure-lab

An example module and terragrunt configuration for Azure DevOps lab.  

## Done
- a new Azure AD user with a random password and random email address
- a new Azure DevOps project with a sample pipeline
- an Azure KeyVault
- a new role assigned to the user
- the correct permissions so that the user can only access Azure DevOps and
Azure KeyVault, not other resources (the actual permission list may be corrected based on the specific use case)

## Prerequisites

In order to successfully run the module you need to have the following:

1. Azure account with a resource group named 'default' 
2. Azure DevOps organisation and a personal access token for it with admin permissions
3. GitHub personal access token with permissions to access the repository for DevOps pipeline
4. Installed tools: Azure CLI, terraform >=v1.1.7, terragrunt >=v0.36

## Ho to run

1. Copy `env.sh.template` to `env.sh` and fill the script with your personal tokens.
2. Configure your Azure DevOps and GitHub organosations in terragrunt.hcl
3. Login with Azure CLI: `az login`
4. Run `./env.sh apply`

## Clean up

Run `./env.sh destroy`