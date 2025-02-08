#################################################
# In this file we will define each one of the   #
# modules, its source and variables to use      #
#################################################

# Here we will define the VPC Module
module "vpc" {
  # We will set the relative path to the VPC module
  source = "./vpc"
  vpc_configuration = var.vpc_configuration
}

# Here we will define the Public Subnet Module
module "public_subnet" {
  # We will set the relative path to the Public Subnet module
  source = "./subnets/public_subnet"
  # We also need to give this module the value of the VPC ID that we will
  # extract from the VPC module
  vpc_id = module.vpc.vpc_id
  public_subnet1_cidr = "10.0.0.0/24"
  public_subnet2_cidr = "10.0.1.0/24"
  public_subnet_1_availability_zone = "il-central-1c"
  public_subnet_2_availability_zone = "il-central-1b"
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

# Here we define the EC2 Module
module "ec2_instances" {
  source = "./ec2"
  # To create EC2 instances we need to give a list of EC2 object with the paramethers defined in the variable.tf file of the module
  ec2_instances = [{
    # We set the AMI for the EC2
    ami = "ami-010cba0c0c7a0e510"
    # We set the type of the EC2
    instance_type = "t3.micro"
    # We set the ssh key name
    key_name = "test_ssh_key"
    # We set the security groups we want to attach to the EC2
    vpc_security_group_ids = [module.security_group.allow_ssh_and_ping_security_group_id]
    # We set the Subnet we want to attach the EC2 to
    subnet_id = module.public_subnet.public_subnet_id
    # We set the private IP
    private_ip = "10.0.0.10"
    # We set the volume size in GB
    root_volume_size = 30
    # We set the type of volume
    volume_type = "gp3"
    # We define if the volume should be deleted if the EC2 is terminated
    delete_on_termination = true
    # We set the tags for the EC2
    tags = {
      Name = "Test_EC2_Machine"
    }
  }]
}

# Here we define the SSL certificate Module
# THe purpouse of it is to upload SSL certificates to AWS
module "ssl_certificates" {
  source = "./ssl_certs"
  ssl_certificates = var.ssl_certificates
}

# Here we define the Load Balancer Module
module "load_balancer" {
  source = "./load_balancer"
  load_balancer = {
    # We set the name of the LB
    name = "testelb"
    # We define if it will be internal or not
    internal = false
    # We set the type of LB
    type = "application"
    # We set the security groups we want to attach to the LB
    security_groups = [module.security_group.sg_for_elb_id]
    # We set the subnets we want to set the LB into
    # LB needs to be in at least 2 subnets that are located on 2 different Availability Zones
    subnets = [module.public_subnet.public_subnet_id, module.public_subnet.public_subnet2_id]
    # We set the VPC ID
    vpc_id = module.vpc.vpc_id
    # Here we define the tartgets
    # These are the EC2 machines that hosts the Web Servers

    # We set a name for the targets
    target_group_name = "webservers"
    # We define the port the targets are listening to
    target_group_port = 80
    # We define the protocol the targets are listening to
    target_group_protocol = "TCP"

    # Here we define the HTTP Listener, this is the port and protocol the LB will be listening for connections
    # We define what the action of the listener will be
    http_listener_action = "forward"
    # We define the port the LB will be listening for connections
    http_listener_port = 80
    # We define the protocol the LB will be listening for connections
    http_listener_protocol = "TCP"
    # Here we define the HTTPS Listener, this is the port and protocol the LB will be listening for connections
    # We define what the action of the listener will be
    https_listener_action = "forward"
    # We define the port the LB will be listening for connections
    https_listener_port = 443
    # We define the protocol the LB will be listening for connections
    https_listener_protocol = "TCP"
    # Here we give the load balancer a list of EC2 instances that will be in the target group
    instance_ids = [module.ec2_instances.ec2_instance_ids[0]] #, module.ec2_instances.ec2_instance_ids[1]]
    # For the HTTPs listener we give the arn of the SSL certificate we uploaded on the SSL module
    ssl_arn = module.ssl_certificates.ssl_certificate_arns[0]
  }
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

# Here we define the RDS DB module
module "rds_database" {
  source = "./databases/rds"
  rds_instance = {
    identifier = "postgrestest"
    instance_class = "db.t3.micro"
    allocated_storage = 5
    engine = "postgres"
    engine_version = "14.14"
    username = var.postgress_user
    password = var.postgres_password
    db_subnet_group_name = "postgres_db"
    db_subnet_group_name_tag_name = "postgress_db"
    subnet_ids = [module.public_subnet.public_subnet_id, module.public_subnet.public_subnet2_id]
    security_group_id = [module.security_group.postgres_sg_id]
    publicly_accessible = true
    skip_final_snapshot = true
    parameter_group_name = "postgres"
    parameter_group_family = "postgres14"
  }
}