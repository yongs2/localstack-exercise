variable "clusterId" {
  default = "mysamplecluster"
}

variable "dbName" {
  default = "mydb"
}

variable "masterUsername" {
  default = "masteruser"
}

# expected length of master_password to be in the range (8 - 64)
# must contain at least one uppercase letter
variable "masterPassword" {
  default = "Mustbe8characters"
}

# awslocal redshift \
#     create-cluster \
#     --cluster-identifier mysamplecluster \
#     --master-username masteruser \
#     --master-user-password secret1 \
#     --node-type ds2.xlarge \
#     --cluster-type single-node
resource "aws_redshift_cluster" "mycluster" {
  cluster_identifier = var.clusterId
  database_name      = var.dbName
  master_username    = var.masterUsername
  master_password    = var.masterPassword
  node_type          = "ds2.xlarge"
  cluster_type       = "single-node"
}

# return redshift cluster
output "cluster" {
  value = aws_redshift_cluster.mycluster
  sensitive = true
}
