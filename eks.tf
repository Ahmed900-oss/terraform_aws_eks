provider "kubernetes" {
  config_path            = "false"
  host                   = data.aws_eks_cluster.myapp-cluster.endpoint
  token                  = data.aws_eks_cluster_auth.myapp-cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority.0.data)
}
data "aws_eks_cluster" "myapp-cluster" {
  name = module.eks.cluster_id

}
data "aws_eks_cluster_auth" "myapp-cluster" {
  name = module.eks.cluster_id
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.10.0"

  cluster_name    = "myapp-eks-cluster"
  cluster_version = "1.29"

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id

  tags = {
    environmemt = "development"
    application = "myapp"
  }

  eks_managed_node_groups = [
    {
      instance_type        = "t3.small"
      name                 = "worker-group-1"
      asg_desired_capacity = 2
    },
    {
      instance_type        = "t3.meduim"
      name                 = "worker-group-2"
      asg_desired_capacity = 1
    }
  ]
}
