resource "google_sql_ssl_cert" "client_cert" {
  common_name = "init"
  instance    = "${module.cloudsql.cloudsql-instance-name}"
  depends_on = ["module.cloudsql.cloudsql-instance-name"]
}

resource "local_file" "server_ca" {
    sensitive_content = "${google_sql_ssl_cert.client_cert.server_ca_cert}"
    filename = "${path.module}/server-ca.pem"
    depends_on = ["google_sql_ssl_cert.client_cert"]
}

resource "local_file" "client_cert" {
    sensitive_content = "${google_sql_ssl_cert.client_cert.cert}"
    filename = "${path.module}/client-cert.pem"
    depends_on = ["google_sql_ssl_cert.client_cert"]
}

resource "local_file" "client_key" {
    sensitive_content = "${google_sql_ssl_cert.client_cert.private_key}"
    filename = "${path.module}/client-key.pem"
    depends_on = ["google_sql_ssl_cert.client_cert"]
}

resource "null_resource" "truststore_keystore" {
  triggers = {
    always = "${uuid()}"
  }
  provisioner "local-exec" {
    command = <<EOF
keytool -delete -alias clientalias -keystore keystore -storepass changeit || 
keytool -import -noprompt -file ${path.module}/server-ca.pem -keystore truststore -storepass changeit && 
openssl pkcs12 -export -in ${path.module}/client-cert.pem -inkey ${path.module}/client-key.pem -out client.p12 -password pass:changeit -name clientalias -CAfile ${path.module}/server-ca.pem && 
keytool -importkeystore -noprompt -deststorepass changeit -destkeystore keystore -srckeystore client.p12 -srcstoretype PKCS12 -srcstorepass changeit -alias clientalias
EOF
  }
  depends_on = [
    "local_file.server_ca",
    "local_file.client_cert",
    "local_file.client_key"
  ]
}

data "local_file" "truststore" {
  filename = "${path.module}/truststore"
  depends_on = ["null_resource.truststore_keystore"]
}

data "local_file" "keystore" {
  filename = "${path.module}/keystore"
  depends_on = ["null_resource.truststore_keystore"]
}
