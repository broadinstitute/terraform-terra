provider "vault" {}

data "google_service_account" "firecloud_orchestration" {
  account_id = "${var.firecloud_orchestration_service_account}"
}

data "google_project" "google_project" {
  project_id = "${var.google_project}"
}

data "vault_generic_secret" "current_aou_perf_audiences" {
  path = "secret/dsde/firecloud/common/perf_fake_research_aou_oauth_client_ids"
}

data "null_data_source" "env_specific_oauth_audiences" {
  inputs = {
    firecloud_orchestration_id = data.google_service_account.firecloud_orchestration.unique_id
    local_project_id = data.google_project.google_project.number 
  }
}

data "null_data_source" "env_specific_aou_oauth_audiences" {
  inputs = {}
}

module "legacy_oauth_audiences" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/merged_oauth_audiences?ref=rl-merged-oauth-audiences"
  original_audience_secret_path = "secret/dsde/firecloud/common/oauth_client_id"
  new_audience_secret_path = "${var.vault_path_prefix}/common/oauth_client_id"
  values_to_merge = data.null_data_source.env_specific_oauth_audiences.outputs
}

module "terra_oauth_audiences" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/merged_oauth_audiences?ref=rl-merged-oauth-audiences"
  original_audience_secret_path = "secret/dsde/firecloud/common/non_aou_oauth_client_ids"
  new_audience_secret_path = "${var.vault_path_prefix}/common/non_aou_oauth_client_ids"
  values_to_merge = data.null_data_source.env_specific_oauth_audiences.outputs
}

module "perf_fake_research_aou_oauth_client_ids" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/merged_oauth_audiences?ref=rl-merged-oauth-audiences"
  original_audience_secret_path = "secret/dsde/firecloud/common/perf_fake_research_aou_oauth_client_ids"
  new_audience_secret_path = "${var.vault_path_prefix}/common/perf_fake_research_aou_oauth_client_ids"
  values_to_merge = data.null_data_source.env_specific_aou_oauth_audiences.outputs
}

module "research_aou_oauth_client_ids" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/merged_oauth_audiences?ref=rl-merged-oauth-audiences"
  original_audience_secret_path = "secret/dsde/firecloud/common/research_aou_oauth_client_ids"
  new_audience_secret_path = "${var.vault_path_prefix}/common/research_aou_oauth_client_ids"
  values_to_merge = data.null_data_source.env_specific_aou_oauth_audiences.outputs
}

module "fake_research_aou_oauth_client_ids" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/merged_oauth_audiences?ref=rl-merged-oauth-audiences"
  original_audience_secret_path = "secret/dsde/firecloud/common/fake_research_aou_oauth_client_ids"
  new_audience_secret_path = "${var.vault_path_prefix}/common/fake_research_aou_oauth_client_ids"
  values_to_merge = data.null_data_source.env_specific_aou_oauth_audiences.outputs
}

module "stable_fake_research_aou_oauth_client_ids" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/merged_oauth_audiences?ref=rl-merged-oauth-audiences"
  original_audience_secret_path = "secret/dsde/firecloud/common/stable_fake_research_aou_oauth_client_ids"
  new_audience_secret_path = "${var.vault_path_prefix}/common/stable_fake_research_aou_oauth_client_ids"
  values_to_merge = data.null_data_source.env_specific_aou_oauth_audiences.outputs
}

module "staging_fake_research_aou_oauth_client_ids" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/merged_oauth_audiences?ref=rl-merged-oauth-audiences"
  original_audience_secret_path = "secret/dsde/firecloud/common/staging_fake_research_aou_oauth_client_ids"
  new_audience_secret_path = "${var.vault_path_prefix}/common/staging_fake_research_aou_oauth_client_ids"
  values_to_merge = data.null_data_source.env_specific_aou_oauth_audiences.outputs
}
