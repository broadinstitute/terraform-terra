resource "google_storage_bucket_object" "docker-compose" {
  count = "${length(data.google_compute_instance_group.service-instances.instances)}"
  name   = "${element(split("/", element(data.google_compute_instance_group.service-instances.instances, count.index)), length(split("/", element(data.google_compute_instance_group.service-instances.instances, count.index))) - 1)}/configs/docker-compose.yaml"
  source = "${local_file.docker_compose.filename}"
  bucket = "${var.config_bucket_name}"
  depends_on = ["local_file.docker_compose"]
}

resource "google_storage_bucket_object" "mongo-server-conf" {
  count = "${length(data.google_compute_instance_group.service-instances.instances)}"
  name   = "${element(split("/", element(data.google_compute_instance_group.service-instances.instances, count.index)), length(split("/", element(data.google_compute_instance_group.service-instances.instances, count.index))) - 1)}/configs/mongod.conf"
  source = "${local_file.mongo_server_conf.filename}"
  bucket = "${var.config_bucket_name}"
  depends_on = ["local_file.mongo_server_conf"]
}
