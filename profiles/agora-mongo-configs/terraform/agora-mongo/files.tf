data "google_client_config" "app-engine" {
}

resource "local_file" "docker_compose" {
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
    #volumes:
    #  - ${var.mongodb_data_path}:/bitnami/mongodb
EOT
  filename = "${path.module}/docker-compose.yaml"
}

resource "local_file" "mongo_arbiter_conf" {
  content = <<EOT
#!/bin/bash
# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: false
   #engine:
  mmapv1:
    smallFiles: true

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# network interfaces
net:
  port: 27017
  bindIp: 0.0.0.0

replication:
  replSetName: ${var.owner}-${var.service}
EOT
  filename = "${path.module}/mongod_arbiter.conf"
}

resource "local_file" "mongo_server_conf" {
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
  filename = "${path.module}/mongod_server.conf"
}
