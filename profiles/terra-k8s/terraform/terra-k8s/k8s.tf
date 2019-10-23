module "terra-k8s" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s?ref=k8s-0.2.0-tf-0.12"

  # Alias of the provider you want to use--the provider's project controls the resource project
  providers = {
    google = "google-beta"
  }

  /*
  * REQUIRED VARIABLES
  */
  
  k8s_version = var.k8s_version

  # Name for your cluster (use dashes not underscores)
  cluster_name = var.terra_cluster_name

  # Network where the cluster will live (must be full resource path)
  cluster_network = var.cluster_network

  # Subnet where the cluster will live (must be full resource path)
  cluster_subnetwork = var.cluster_subnetwork

  # CIDR to use for the hosted master netwok. must be a /28 that does NOT overlap with the network k8s is on
  private_master_ipv4_cidr_block = var.private_master_ipv4_cidr_block
  
  # CIDRs of networks allowed to talk to the k8s master
  master_authorized_network_cidrs = var.broad_range_cidrs

  /*
  * OPTIONAL VARIABLES (values are the defaults)
  */
  
  # Disk size for the nodes in the cluster
  node_pool_disk_size_gb = "100"

  # number of nodes in your node pool
  node_pool_count = "3"

  # Machine type of the nodes
  node_pool_machine_type = "n1-highmem-8"

  # service account credentials to give the nodes, empty string means default
  node_service_account = ""

  # labels to give the nodes
  node_labels = {}
  
  # tags to give the nodes
  node_tags = []

  # Restrict visibility to node metadata
  workload_metadata_config_node_metadata = "SECURE"
}
