data "google_client_config" "app-engine" {
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
