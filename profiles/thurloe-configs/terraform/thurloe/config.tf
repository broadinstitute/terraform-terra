provider "vault" {}

resource "vault_token" "render_token" {
  policies = ["${var.config_render_vault_policy}"]

  renewable = true
  ttl = "20m"
}

resource "null_resource" "config" {
  triggers = {
    always = "${uuid()}"
  }
  provisioner "local-exec" {
    command = "ruby /workbench/render_configs.rb"
    environment = {
      INSTANCES = "${jsonencode(data.google_compute_instance_group.service-instances.instances)}"
      CONFIG_BUCKET = "${var.config_bucket_name}"
      VAULT_TOKEN = "${vault_token.render_token.client_token}"
      GITHUB_TOKEN_VAULT_PATH = "${var.github_token_vault_path}"
      INSTANCE_TYPE = "${var.instance_type}"
      RUN_CONTEXT = "${var.run_context}"
      APP_NAME = "${var.app_name}"
      ENV = "${var.environment}"
      GITHUB_ORG = "${var.github_org}"
      GIT_REPO = "${var.git_repo}"
      GIT_BRANCH = "${var.firecloud_develop_git_branch}"
      HOST_TAG = "${var.host_tag}"
      IMAGE = "${var.service_git_sha_12_char}"
      TARGET_DOCKER_VERSION = "${var.target_docker_version}"
      VAULT_ADDR = "${var.vault_addr}"
      GOOGLE_PROJ = "${var.google_project}"
      GOOGLE_APPS_DOMAIN = "${var.google_apps_domain}"
      GOOGLE_APPS_ORGANIZATION_ID = "${var.google_apps_organization_id}"
      GOOGLE_APPS_SUBDOMAIN = "${var.google_apps_subdomain}"
      GCS_NAME_PREFIX = "${var.gcs_name_prefix}"
      DNS_DOMAIN = "${var.config_dns_domain}"
      LDAP_BASE_DOMAIN = "${var.ldap_base_domain}"
      BUCKET_TAG = "${var.bucket_tag}"
    }
  }
}
