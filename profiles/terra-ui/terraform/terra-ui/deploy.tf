resource "null_resource" "gae_deploy" {
  triggers = {
    gae_commit = "${var.terra_ui_git_commit}"
    always = "${uuid()}"
  }
  provisioner "local-exec" {
    command = "/bin/bash ${local_file.deploy_script.filename}"
  }
  depends_on = ["local_file.deploy_script", "local_file.config_json", "module.enable-services"]
}
