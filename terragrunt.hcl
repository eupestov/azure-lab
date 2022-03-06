terraform {
  source = "modules/lab"

  extra_arguments "conditional_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "refresh",
      "destroy"
    ]

    env_vars = {
      AZDO_ORG_SERVICE_URL = "https://dev.azure.com/epestov"
    }
  }
}

inputs = {
  mail_domain = "eugenepestovgmail.onmicrosoft.com"

  github_org_name              = "eupestov"
  github_repo_name             = "azure-lab"
}