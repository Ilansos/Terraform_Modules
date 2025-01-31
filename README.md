# Collection of Terraform Modules

This repository contains a collection of Terraform modules designed to facilitate the deployment and management of various AWS resources. Each module is self-contained and focuses on a specific aspect of infrastructure provisioning.

## Modules Overview

Each module is located in its respective directory and is designed to be reusable and configurable. Below is a brief description of each module:

- CloudTrail Module: Manages AWS CloudTrail configurations for logging and monitoring account activity.
- EC2 Module: Provisions and manages EC2 instances with customizable parameters.
- Groups Module: Manages IAM groups and their associated policies.
- Policies Module: Defines and attaches IAM policies to users, groups, or roles.
- S3 Module: Creates and manages S3 buckets with configurable settings.
- Security Group Module: Sets up security groups with specified ingress and egress rules.
- SSH Keys Module: Manages SSH key pairs for secure access to EC2 instances.
- Subnets Module: Configures subnets within a VPC, including CIDR blocks and routing.
- Users Module: Manages IAM users and their permissions.
- VPC Module: Sets up a Virtual Private Cloud with associated components like subnets and route tables.


## How To

To provision the the infrastructure you need:

1. Clone the repo:

```bash
git clone https://github.com/Ilansos/Terraform_Modules.git && cd Terraform_Modules
```

2. Install Terraform and AWS CLI according to their instructions:

- https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
- https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

3. Create an user and an access key for it

Make sure you give him the relevant permissions

4. Configure AWS with your Access Key and Secret

```bash
aws configure
```

5. Initiallize Terraform

```bash
terraform init
```

6. Validate the configuration

```bash
terraform validate
```

7. Plan the configuration

Verify that it creates the resources you want

```bash
terraform plan -var-file="main_variables.tfvars"
```

8. Apply the configuration

This command will actually provision the infrastructure

```bash
terraform apply -var-file="main_variables.tfvars"
```

9. You can delete all the infrastructure with the following command:

```bash
terraform destroy -var-file="main_variables.tfvars"
```

## Disclaimer

When utilizing the modules in this repository to provision AWS resources, be aware that deploying and managing these resources may incur costs on your AWS account. It's essential to review AWS's pricing details for each service to understand potential charges. Additionally, consider implementing AWS Budgets and setting up cost alerts to monitor and manage your expenses effectively.
