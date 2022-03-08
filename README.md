# azure-lab

An example module and terragrunt configuration for Azure DevOps lab.  

## Done
- a new Azure AD user with a random password and random email address
- a new Azure DevOps project with a sample pipeline
- an Azure KeyVault
- a new role assigned to the user
- the correct permissions so that the user can only access Azure DevOps and
Azure KeyVault, not other resources (the actual permission list may be corrected based on the specific use case)

## Ho to run

    export AZDO_PERSONAL_ACCESS_TOKEN=<>
    export TF_VAR_github_personal_access_token=<>
    terragrunt apply

Destroy

    terragrunt destroy