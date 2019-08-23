output "hostname" {
  value = "${data.null_data_source.hostnames_with_no_trailing_dot.outputs.hostname}"
}
