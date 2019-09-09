resource "null_resource" "elasticsearch_init" {
  triggers = {
    always = "${uuid()}"
  }
  provisioner "local-exec" {
    command = <<EOF
curl -X PUT "http://${var.elasticsearch_hostname}:9200/ontology/" -H 'Content-Type: application/json' -d '{"settings":{"index":{"number_of_replicas":${var.elasticsearch_num_replicas}}}}'
EOF
  }
}
