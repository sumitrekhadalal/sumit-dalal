################################################################################
# VPC
################################################################################

resource "aws_vpc" "myVPC" {
  cidr_block = var.cidr
  tags = {
    Name = var.vpc_name
  }
}

###############################################################################
# Internet Gateway
###############################################################################

resource "aws_internet_gateway" "myIGW" {

  vpc_id = aws_vpc.myVPC.id
  tags = {
    "Name" = var.igw_tag
  }
}

################################################################################
# Public subnet
################################################################################

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.myVPC.id
  cidr_block              = var.public_subnets_cidr_1
  availability_zone       = data.aws_availability_zones.available_1.names[0]
  #map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = var.public_subnet_tag_1
  }
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.myVPC.id
  cidr_block              = var.public_subnets_cidr_2
  availability_zone       = data.aws_availability_zones.available_1.names[1]
  #map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = var.public_subnet_tag_2
  }
}

################################################################################
# Database subnet
################################################################################

resource "aws_subnet" "database_subnet_1" {
  vpc_id                  = aws_vpc.myVPC.id
  cidr_block              = var.database_subnets_cidr_1
  availability_zone       = data.aws_availability_zones.available_1.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = var.database_subnet_tag_1
  }
}
resource "aws_subnet" "database_subnet_2" {
  vpc_id                  = aws_vpc.myVPC.id
  cidr_block              = var.database_subnets_cidr_2
  availability_zone       = data.aws_availability_zones.available_1.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = var.database_subnet_tag_2
  }
}

################################################################################
# Publiс routes
################################################################################

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.myVPC.id
  tags = {
    Name = var.public_route_table_tag
  }
}
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = var.rout-destinetion-igw
  gateway_id             = aws_internet_gateway.myIGW.id
}

################################################################################
# Database route table
################################################################################

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = var.database_route_table_tag
  }
}

################################################################################
# Route table association with subnets
################################################################################

resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "database_route_table_association_1" {
  subnet_id      = aws_subnet.database_subnet_1.id
  route_table_id = aws_route_table.database_route_table.id
}
resource "aws_route_table_association" "database_route_table_association_2" {
  subnet_id      = aws_subnet.database_subnet_2.id
  route_table_id = aws_route_table.database_route_table.id
}

###############################################################################
# Security Group
###############################################################################

resource "aws_security_group" "sg" {
  name        = var.default_security_group_name
  description = var.sg-description
  vpc_id      = aws_vpc.myVPC.id

  dynamic "ingress" {
    for_each = local.ingress_rules


    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



  tags = {
    Name = "tcw_security_group"
  }
}



locals {
  ingress_rules = [{
    port        = 22
    description = "this is ssh port"
    },
    {
      port        = 443
      description = "this is https port"
    },
    {
      port        = 80
      description = "this is http port"
  }]

}

####################################################################
# ec2-instance
###################################################################ami                         = var.ami_id # us-east-1
  
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.database_subnet_1.id
  associate_public_ip_address = true
  user_data                   = <<EOF
  
  #!/bin/bash
apt update -y
apt install httpd -y
echo "hellow this is me $HOSTNAME" >> /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
EOF

  tags = {
    Name = "pub-instance"
  }
}

####################################################################
  # EBS -valume
####################################################################


resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = "us-east-1a"
  size              = 10
  snapshot_id       = null
  type              = "gp2"
  tags = {
    Name         = "ebs_volume"
    application  = var.application
    organization = var.organization
  }
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.ebs_volume.id
  instance_id = aws_instance.web.id
}

