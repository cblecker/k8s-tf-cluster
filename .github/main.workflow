workflow "Terraform" {
  resolves = "terraform-validate"
  on = "pull_request"
}

action "filter-to-pr-open-synced" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

action "terraform-fmt" {
  uses = "hashicorp/terraform-github-actions/fmt@v0.3.1"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "."
  }
}

action "terraform-init" {
  uses = "hashicorp/terraform-github-actions/init@v0.3.1"
  needs = "terraform-fmt"
  secrets = ["GITHUB_TOKEN", "TF_ACTION_TFE_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "."
    TF_ACTION_TFE_HOSTNAME = "app.terraform.io"
  }
}

action "terraform-validate" {
  uses = "hashicorp/terraform-github-actions/validate@v0.3.1"
  needs = "terraform-init"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "."
  }
}
