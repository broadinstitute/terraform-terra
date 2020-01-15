
module "k8s-master" {
  # terraform-shared repo
  source     = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s-master?ref=k8s-master-0.1.0-tf-0.12"
  dependencies = [
    module.enable-services,
    google_compute_network.k8s-cluster-network
  ]

  name = var.cluster_name
  location = var.cluster_location
  version_prefix = var.k8s_version_prefix
  network = var.cluster_network
  subnetwork = var.cluster_network
  authorized_network_cidrs = var.authorized_network_cidrs
  private_ipv4_cidr_block = var.private_master_ipv4_cidr_block
}

module "k8s-node-pool" {
  # terraform-shared repo
  source     = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s-node-pool?ref=k8s-node-pool-0.1.0-tf-0.12"
  dependencies = [
    module.k8s-master
  ]

  name = var.node_pools[0].name
  master_name = module.k8s-master.name
  location = var.cluster_location
  node_count = var.node_pools[0].node_count
  machine_type = var.node_pools[0].machine_type
  disk_size_gb = var.node_pools[0].disk_size_gb
  labels = var.node_pools[0].labels
  tags = [ "k8s-${module.k8s-master.name}-node-${var.node_pools[0].name}" ]
}
