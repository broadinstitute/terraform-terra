resource "google_storage_bucket_object" "docker-compose" {
  count = "${length(data.google_compute_instance_group.service-instances.instances)}"
  name   = "${element(split("/", element(data.google_compute_instance_group.service-instances.instances, count.index)), length(split("/", element(data.google_compute_instance_group.service-instances.instances, count.index))) - 1)}/configs/docker-compose.yaml"
  content = <<EOT
version: '2'
services:
  mongodb:
    image: bitnami/mongodb:3.4.4-r1
    ports:
      - "${var.mongodb_host_port}:${var.mongodb_container_port}"
    environment:
      - MONGODB_ROOT_PASSWORD=${random_id.mongodb-root-password.hex}
      - MONGODB_USERNAME=${var.mongodb_app_username}
      - MONGODB_PASSWORD=${random_id.mongodb-user-password.hex}
      - MONGODB_DATABASE=${var.mongodb_database}
      - MONGODB_PRIMARY_PORT=${var.mongodb_container_port}
#    volumes:
#      - ${var.mongodb_data_path}:/bitnami/mongodb
    restart: always
EOT
  bucket = "${var.config_bucket_name}"
}

resource "google_storage_bucket_object" "mongo-server-conf" {
  count = "${length(data.google_compute_instance_group.service-instances.instances)}"
  name   = "${element(split("/", element(data.google_compute_instance_group.service-instances.instances, count.index)), length(split("/", element(data.google_compute_instance_group.service-instances.instances, count.index))) - 1)}/configs/mongod.conf"
  content = <<EOT
#!/bin/bash
# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
storage:
  dbPath: /mnt/mongodb/db
  journal:
    enabled: true
   #engine:
  #mmapv1:
    #smallFiles: true
#  wiredTiger:

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /mnt/mongodb/log/mongodb.log

# network interfaces
net:
  port: 27017
  bindIp: 0.0.0.0

replication:
  replSetName: ${var.owner}-${var.service}
EOT
  bucket = "${var.config_bucket_name}"
}
