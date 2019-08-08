resource "google_storage_bucket_object" "docker-compose" {
  count = "${length(data.google_compute_instance_group.service-instances.instances)}"
  name   = "${element(split("/", element(data.google_compute_instance_group.service-instances.instances, count.index)), length(split("/", element(data.google_compute_instance_group.service-instances.instances, count.index))) - 1)}/configs/docker-compose.yaml"
  content = <<EOT
version: '2'
services:
  pagerduty-alert:
    image: gcr.io/broad-dsde-dev/pagerduty-alert:latest
    dns:
      - 172.17.42.1
    environment:
      - TEST=test
    volumes:
      - /app/:/app/
    restart: always
EOT
  bucket = "${var.config_bucket_name}"
}
