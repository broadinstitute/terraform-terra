consul {
  address = "localhost:8500"
  token = ""
}
log_level = "info"
vault {
  address = "https://clotho.broadinstitute.org:8200"
  token = ""
  ssl {
    enabled = true
    verify = true
    cert = ""
    ca_cert = ""
  }
}
