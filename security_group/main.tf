################################################################
# In this example we will create a security group that will    #
# allow SSH traffic to the instance and also the ICMP protocol #
################################################################

# Here we create the resource
resource "aws_security_group" "allow_ssh_and_ping" {
  # We can give a name to the security group
  name = "allow_ssh_and_ping"
  # We can also give a description
  description = "Allow SSH and ICMP in from a specific IP"
  # We need to assign the security group to the correct VPC
  vpc_id = var.vpc_id

  # We will set an "ingress" block for each rule
  # The first block will allow SSH from an CIDR that was defined in the variable.tf file
  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = var.ssh_allow_cidr
  }

  # We create a second ingress block to allow ICMP
  ingress {
    from_port = -1 # Use -1 for all ICMP types and codes use a port
    to_port = -1
    protocol = "ICMP"
    cidr_blocks = var.icmp_allow_cidr
  }

  # We need to create also an "egress" block that will allow traffic from the instance
  # Without this block the instance will not be able to communicate with any other device
  # This rule will allow traffic from the instance to "Any"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_for_elb" {
  name = "sg_for_elb"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow HTTP request from any"
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS request from any"
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_allow_from_elb" {
  name = "sg_allow_from_elb"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow HTTP traffic only from the ELB security group"
    protocol = "tcp"
    from_port = 80
    to_port = 80
    security_groups = [aws_security_group.sg_for_elb.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "postgres_security_group" {
  name = "postgres-sg"
  description = "Allow PostgreSQL inbound"
  vpc_id = var.vpc_id

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = var.my_ip_cidr
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}