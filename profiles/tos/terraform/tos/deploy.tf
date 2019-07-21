resource "null_resource" "get_repo" {
  triggers = {
    function_git_refspec = "${var.function_git_refspec}"
    always = "${uuid()}"
  }
  provisioner "local-exec" {
    command = "/bin/bash ${local_file.get_repo.filename}"
  }
  depends_on = []
}

resource "null_resource" "deploy_prep" {
  triggers = {
    function_git_refspec = "${var.function_git_refspec}"
    always = "${uuid()}"
  }
  provisioner "local-exec" {
    command = "/bin/bash ${local_file.deploy_prep.filename}"
  }
  depends_on = ["null_resource.get_repo"]
}

resource "null_resource" "function_upload" {
  triggers = {
    function_git_refspec = "${var.function_git_refspec}"
    always = "${uuid()}"
  }
  provisioner "local-exec" {
    command = "/bin/bash ${local_file.function_upload.filename}"
  }
  depends_on = ["null_resource.deploy_prep"]
}
