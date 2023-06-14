
# Define a custom vpc with the cidr
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.cidr["vpc_cidr"]
  enable_dns_hostnames = true
  tags                 = local.tags
}

# ----- Declaring subnet resources  ---------------
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.cidr["public_cidr_1"]
  availability_zone       = data.aws_availability_zones.current.names[0]
  map_public_ip_on_launch = true
}
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.cidr["public_cidr_2"]
  availability_zone       = data.aws_availability_zones.current.names[1]
  map_public_ip_on_launch = true
}
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.cidr["private_cidr_1"]
  availability_zone = data.aws_availability_zones.current.names[0]
}
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.cidr["private_cidr_2"]
  availability_zone = data.aws_availability_zones.current.names[1]
}
# ------- Declaring data_source for availability zones ---------
data "aws_availability_zones" "current" {
  state = "available"
}

# ------------- Declaring the IGW resources--------------------
resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = local.tags
}
# -------------- Declaring the public route-table --------------
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = var.cidr["local_route"]
    gateway_id = aws_internet_gateway.main_gw.id # chained resource
  }
  tags = {
    Name = "tf_public_route"
  }
}
# ----------- Route_table_association --------------------------
resource "aws_route_table_association" "public_route_1" {
  route_table_id = aws_route_table.public_route.id # chained resource
  subnet_id      = aws_subnet.public_1.id          # chained resource

}
resource "aws_route_table_association" "public_route_2" {
  route_table_id = aws_route_table.public_route.id # chained resource
  subnet_id      = aws_subnet.public_2.id          # chained resource
}

# ----------- Declaring a nat_gateway -------------------
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main_gw]

  tags = local.tags # take note
}
# ------ Creation of single EIP associated with an instance ------
resource "aws_eip" "nat" {
  vpc        = true
  depends_on = [aws_internet_gateway.main_gw]
}
# ------- Declaring the private route-table ---------------------
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = var.cidr["local_route"]
    nat_gateway_id = aws_nat_gateway.gw.id
  }
  tags = {
    Name = "tf_private_route"
  }
}
# Route_table_association
resource "aws_route_table_association" "private_route_1" {
  route_table_id = aws_route_table.private_route.id # chained resource
  subnet_id      = aws_subnet.private_1.id          # chained resource

}
resource "aws_route_table_association" "private_route_2" {
  route_table_id = aws_route_table.private_route.id # chained resource
  subnet_id      = aws_subnet.private_2.id          # chained resource
}

# --------- Declaring the aws_network_acl for public -------------
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.my_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 20
    action     = "allow"
    cidr_block = var.cidr["public_nacl"]
    from_port  = var.allowed_ports[3]
    to_port    = var.allowed_ports[3]
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 10
    action     = "allow"
    cidr_block = var.cidr["public_nacl"]
    from_port  = var.allowed_ports[3]
    to_port    = var.allowed_ports[3]
  }
  tags = local.tags
}
# --------- Declaring the subnet asso for Nacls ------------------
resource "aws_network_acl_association" "pub_ass_1" {
  network_acl_id = aws_network_acl.public_nacl.id
  subnet_id      = aws_subnet.public_1.id
}
resource "aws_network_acl_association" "pub_ass_" {
  network_acl_id = aws_network_acl.public_nacl.id
  subnet_id      = aws_subnet.public_2.id
}

# --------- Declaring the aws_network_acl private ----------------
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.my_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 10
    action     = "allow"
    cidr_block = var.cidr["private_nacl"]
    from_port  = var.allowed_ports[3]
    to_port    = var.allowed_ports[3]
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 20
    action     = "allow"
    cidr_block = var.cidr["private_nacl"]
    from_port  = var.allowed_ports[3]
    to_port    = var.allowed_ports[3]
  }
  tags = local.tags
}
# --------- Declaring the subnet asso for private Nacls ----------
resource "aws_network_acl_association" "priv_ass_1" {
  network_acl_id = aws_network_acl.private_nacl.id
  subnet_id      = aws_subnet.private_1.id
}
resource "aws_network_acl_association" "priv_ass_2" {
  network_acl_id = aws_network_acl.private_nacl.id
  subnet_id      = aws_subnet.private_2.id
}

# --------- Creating aws_security_group --------------------------
resource "aws_security_group" "web_sg" {
  name        = "my_vpc_sg"
  description = "Allow TLS protocol 22 and 80 inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "ssh to instance"
    from_port   = var.allowed_ports[0]
    to_port     = var.allowed_ports[0]
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr[0]] #"var.allowed_cidr"[0]
  }
  ingress {
    description = "http to instance"
    from_port   = var.allowed_ports[1]
    to_port     = var.allowed_ports[1]
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr[1]] #"var.allowed_cidr"[1]
  }
  egress {
    description = "http & ssh from VPC"
    from_port   = var.allowed_ports[3]
    to_port     = var.allowed_ports[3]
    protocol    = "-1"
    cidr_blocks = [var.allowed_cidr[1]] #"var.allowed_cidr[1]"

  }
  tags = local.tags
}

# Creating a data_source for latest aws_ami
data "aws_ami" "amazon_linux_2" {
  owners      = ["amazon"]
  most_recent = true

  filter { # a regex expression
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
# Declaring an aws_key_pair for my instance
data "aws_key_pair" "tf_projects" {
  key_name           = "tf_projects"
  include_public_key = true

  filter {
    name   = "key-pair-id"
    values = ["key-06e11d53dd9f93930"]
  }
}

#creating a Linux 2 EC2 resource   
resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type[0]
  key_name                    = data.aws_key_pair.tf_projects.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  user_data                   = <<-EOF
   #!/bin/bash
   sudo yum update -y
   sudo yum install httpd -y
   echo "<html><body><div>This is one of project3 webservers!</div></body></html>" > /var/www/html/index.html
   sudo systemctl enable httpd
   sudo systemctl start httpd
   EOF
  tags = {
    "Name"       = "terraform-on-aws"
    "Department" = "Development"
    "Maintainer" = var.maintainer
    "Email"      = var.email
  }
}

