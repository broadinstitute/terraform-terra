#
# Thurloe - Common Vars
#
variable "thurloe_tags" {
  default = "http-server,https-server"
  description = "The default instance tags for thurloe"
}

#
# Thurloe - DNS Vars
#
variable "thurloe_load_balancer_dns_cname_record_flag" {
  default = "0"
  description = "Enable DNS CNAME record for default thurloe load balancer in an env. Should be set as a vault env override for each env."
}

variable "thurloe_load_balancer_dns_cname_record_service_hostname" {
  default = ""
  description = "DNS CNAME record service hostname for default thurloe load balancer in an env. Should be set as a vault env override for each env."
}

variable "thurloe_load_balancer_dns_cname_record_target_hostname" {
  default = ""
  description = "DNS CNAME record target hostname for default thurloe load balancer in an env. Should be set as a vault env override for each env."
}

variable "thurloe_app_dns_cname_record_flag" {
  default = "0"
  description = "Enable DNS CNAME record for default thurloe instance in an env. Should be set as a vault env override for each env."
}

variable "thurloe_app_dns_cname_record_service_hostname" {
  default = ""
  description = "DNS CNAME record service hostname for default thurloe instance in an env. Should be set as a vault env override for each env."
}

variable "thurloe_app_dns_cname_record_target_hostname" {
  default = ""
  description = "DNS CNAME record target hostname for default thurloe instance in an env. Should be set as a vault env override for each env."
}


#
#  Thurloe cloudsql DNS vars
#
variable "thurloe_mysql_instance_dns_cname_record_flag" {
  default = "0"
  description = "Enable DNS CNAME record for default thurloe mysql instance in an env. Should be set as a vault env override for each env."
}

variable "thurloe_mysql_instance_dns_cname_record_service_hostname" {
  default = ""
  description = "DNS CNAME record service hostname for default thurloe mysql instance in an env. Should be set as a vault env override for each env."
}

variable "thurloe_mysql_instance_dns_cname_record_target_hostname" {
  default = ""
  description = "DNS CNAME record target hostname for default thurloe mysql instance in an env. Should be set as a vault env override for each env."
}

#
# Thurloe Service Cluster 
#
variable "thurloe_num_hosts" {
  default = "0"
  description = "The default number of Thurloe service hosts per environment"
}

variable "thurloe_instance_size" {
  default = "custom-4-8192" # 4 CPU, 8GB
  description = "The default number of Thurloe service hosts per environment"
}

variable "thurloe_image_name" {
  default = "centos-7-v20190423"
  description = "The default GCE OS platform image for Thurloe 100 service cluster"
}

variable "thurloe_metadata_startup_script" {
   default = "metadata/centos7-docker2.sh"
   description = "Default metadata startup script used when bootstrapping Thurloe 100 instances"
}

variable "thurloe_allow_stopping_for_update" {
   default = "false"
   description = "If set to true, the instance can be stopped for certain changes (common example: resizing the instance)."
}



variable "thurloe_100_instance_group_load_balancer_name" {
  default = "0"
  description = "Determines the name of the load balancer to which the thurloe 100 instance group should be added. Typical value will be the same as the public service name of the load balancer. Examples: thurloe-200-lb, thurloe-load-balancer-100"
}

variable "thurloe_100_instance_group_unmanaged_enable" {
  default = "0"
  description = "Enables GCE instance group for Thurloe 100 service cluster"
}


#
# Thurloe Common Load Balancer (replaces thurloe-NNN-lb entities)
#
variable "thurloe_load_balancer_100_enable" {
  default = "0"
  description = "Enables GCE common load balancer 100 for one or more Thurloe NNN service clusters"
}

#
# Thurloe CloudSQL Variables
#

variable "thurloe_cloudsql_num_instances" {
  default = "1"
  description = "The number of Thurloe CloudSQL 100 instances per environment"
}

variable "thurloe_cloudsql_region" {
  default = "us-central1"
  description = "The region for Thurloe CloudSQL 100 instances. NOTE: For Gen 2 instance, use standard gcloud regions."
}

variable "thurloe_cloudsql_tier" {
  default = "db-n1-standard-1"
  description = "The default tier (DB instance size) for Thurloe CloudSQL 100 instances"
}

variable "thurloe_cloudsql_database_name" {
  default = "thurloe"
  description = "cloudsql database name for thurloe application"
}

variable "thurloe_cloudsql_app_username" {
  default = "thurloe"
  description = "cloudsql database user name for thurloe application"
}

variable "thurloe_cloudsql_app_password" {
  default = ""
  description = "cloudsql database user password for thurloe application"
}

variable "thurloe_cloudsql_root_password" {
  default = ""
  description = "cloudsql database root password for thurloe application"
}

