terraform {
  source = ".//modules/lab"
}

inputs = {
  mail_domain = "eugenepestovgmail.onmicrosoft.com"

  azdo_organization = "epestov"
  github_org_name   = "eupestov"
  github_repo_name  = "azure-lab"
}