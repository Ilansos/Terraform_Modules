#################################################
# In this file we will define each one of the   #
# modules, its source and variables to use      #
#################################################

# Here we will define the VPC Module
module "vpc" {
  # We will set the relative path to the VPC module
  source = "./vpc"
}

# Here we will define the Public Subnet Module
module "public_subnet" {
  # We will set the relative path to the Public Subnet module
  source = "./subnets/public_subnet"
  # We also need to give this module the value of the VPC ID that we will
  # extract from the VPC module
  vpc_id = module.vpc.vpc_id
}

# Here we will define the Security Group Module
module "security_group" {
  # We will set the relative path to the Security Group Module
  source = "./security_group"
  # We also need to give this module the value of the VPC ID that we will
  # extract from the VPC module
  vpc_id = module.vpc.vpc_id
}

# Here we define the Upload SSH Keys Module
module "upload_ssh_keys" {
  # We set the relative path of the module
  source = "./ssh_keys"
  # We defined the value of each key on the main_variables.tfvars
  ssh_keys = var.ssh_keys
}

module "ec2_instances" {
  source = "./ec2"
  ec2_instances = [{
    ami = "ami-010cba0c0c7a0e510"
    instance_type = "t3.micro"
    key_name = "test_ssh_key"
    vpc_security_group_ids = [module.security_group.allow_ssh_and_ping_security_group_id]
    subnet_id = module.public_subnet.public_subnet_id
    private_ip = "10.0.0.10"
    tags = {
      Name = "Test_EC2_Machine"
    }
  }]
}

# Here we define the policies module
module "policies" {
  source = "./policies"
}

# Here we define the groups module
module "groups" {
  source = "./groups"
  # We will pass the arn of the custom policy we create on the poliies module
  enforce_mfa_policy_arn = module.policies.enforce_mfa_policy_arn
}

# Here we define the users module
module "users" {
  source = "./users"
  # We will pass the name of the global users group we create on the groups module
  global_users_name = module.groups.global_users_name
  # We will pass the name of the aws admins group we create on the groups module
  aws_admins_name = module.groups.aws_admins_name
  # Here we will pass the list of users containing their specific groups.
  users_list = [
    {
      name = "user1"
      groups = [module.groups.global_users_name]
    },
    {
      name = "user2"
      groups = [module.groups.global_users_name, module.groups.aws_admins_name]
    }
  ]
}

# Here we will define the S3 Module
module "S3" {
  # We will set the relative path to the S3 Module
  source = "./s3"
  # We defined each bucket on the buckets.tfvars file
  buckets = var.buckets
}

# The cloudtrail module needs an account id 
# With this module we retrieve the id of the account used to create all these resources
# If you want to use other account id you can set it on the variables of the cloudtrail
data "aws_caller_identity" "current" {}

# Here we will define the cloudtrail module
module "cloudtrail" {
  source = "./cloudtrail"
  # We define the cloudtrail_configuration in the main_variables.tfvars file
  cloudtrail_configuration = var.cloudtrail_configuration
  # We set the bucket we created on the S3 module to be the one that will store the
  # logs of the cloudtrail
  cloudtrail_s3_bucket_name = module.S3.bucket_names["home.lab.cloudtrail.bucket"]
  # We pass our account id to the module
  aws_account_id  = data.aws_caller_identity.current.account_id
}