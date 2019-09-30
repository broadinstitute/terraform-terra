output "ATTENTION" {
  value = <<EOF
THIS PROFILE REQUIRES MANUAL STEPS!
The manual steps are required to initialize the mysql database.
To run the manual steps run the script in the profile root:
python manual_steps.py
EOF
}

output "mysql_init_command" {
  value = <<EOF
docker run --rm \
-v $${PWD}/${var.service}/src/main/resources/db/migration:/flyway/sql \
-v ${var.render_dir}${var.service}/:/tmp/rendered/ \
-e JAVA_ARGS="-Djavax.net.ssl.keyStore=/tmp/rendered/keystore \
-Djavax.net.ssl.keyStorePassword=changeit \
-Djavax.net.ssl.trustStore=/tmp/rendered/truststore \
-Djavax.net.ssl.trustStorePassword=changeit" \
broadinstitute/docker-flyway \
-user=${var.service} \
-password=${random_id.user-password.hex} \
-url='jdbc:mysql://${substr(google_dns_record_set.mysql-instance-new.name, 0, length(google_dns_record_set.mysql-instance-new.name) - 1)}/agora?requireSSL=true&useSSL=true' \
migrate
EOF
}
