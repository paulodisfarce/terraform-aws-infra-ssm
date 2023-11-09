module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "VPC-LAB-SSM"
  //CIDR for VPC
  cidr = "171.31.0.0/16"

  //Subnets & AZS
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["171.31.11.0/24", "171.31.22.0/24", "171.31.33.0/24"]
  public_subnets  = ["171.31.101.0/24", "171.31.102.0/24", "171.31.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true


  //Security Group Egress
  default_security_group_egress = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "LAB-SSM"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  name = "EC2-LAB-SSM"

  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.private_subnets[1]
  iam_instance_profile   = module.session_manager.instance_profile_name

  tags = {
    Terraform   = "true"
    Environment = "LAB-SSM"
  }

}

module "session_manager" {
  source = "./aws-sessionManager"

  name         = "EC2SSMRole_TF"
  policy_arn   = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  name_profile = "Instance_SSM_Profile"

}

