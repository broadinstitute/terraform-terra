
# id used to be appended to all resources in shared areas
variable "terra_env_network_name" {
  default = "app-services"
}

variable "broad_routeable_net" {
   default = "69.173.64.0/18"
   description = "Broad's externally routable IP network"
}

variable "broad_range_cidrs" {
  type    = "list"
  default = [ "69.173.64.0/19", 
    "69.173.96.0/20",
    "69.173.112.0/21",
    "69.173.120.0/22",
    "69.173.124.0/23",
    "69.173.126.0/24",
    "69.173.127.0/25",
    "69.173.127.128/26",
    "69.173.127.192/27",
    "69.173.127.224/30",
    "69.173.127.228/32",
    "69.173.127.230/31",
    "69.173.127.232/29",
    "69.173.127.240/28" ]
}

variable "dns_name" {
   default = "dsde-qa-broad"
}

variable "dns_domain" {
   default = "dsde-qa.broadinstitute.org"
}

variable "dns_ttl" {
   default = "300"
}
