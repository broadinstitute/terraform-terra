output "hostname" {
  value = "${substr(google_dns_record_set.dns-cname.name, 0, length(google_dns_record_set.dns-cname.name) - 1)}"
}

output "db_init_cmd" {
  value = <<EOF
docker run --rm \
-v $${PWD}/${var.service}:/working \
-v $${HOME}/.vault-token:/root/.vault-token \
-e CHGLOG_FILE=src/main/resources/changelog-master.xml \
-e ENV=ephemeral/${var.owner} \
-e APP_PROJ=firecloud \
-e APP_NAME=${var.service} \
-e VAULT_TOKEN=/root/.vault-token \
-e VAULT_ADDR=https://clotho.broadinstitute.org:8200 \
-e DB_NAME=${var.service} \
-e DB_USER=${var.service} \
-e DB_PASSWORD=${random_id.user-password.hex} \
-e DB_HOST=${substr(google_dns_record_set.mysql-instance-new.name, 0, length(google_dns_record_set.mysql-instance-new.name) - 1)} \
-e LOG_LEVEL=debug \
-e USE_COMMON_CERTS=0 \
broadinstitute/liquibase:3.5.3 run.sh update
EOF
}
