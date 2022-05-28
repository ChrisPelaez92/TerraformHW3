locals {
  DateTime = timestamp()

}

###### VPC
resource "aws_vpc" "main" {
  cidr_block  = var.ipblock
  tags        = {
  Name        = "var.vpc_name"
  Env         = terraform.workspace
  Date        = local.DateTime
 }
}

###### Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags       = {
    Name     = "var.vpc_name-Internet_Gateway"
    Env      = terraform.workspace
    Date     = local.DateTime
  }
}

#### Nat Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}


##### Public Subnets
resource "aws_subnet" "public" {
  count      = 3
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.ipblock, 5, count.index)

  tags        = {
    Name      = "CPFpublic-${count.index}"
    Env       = terraform.workspace
    Date      = local.DateTime
  }
}


##### Privet Subnets
resource "aws_subnet" "privet" {
  count       = 3
  vpc_id      = aws_vpc.main.id
  cidr_block  = cidrsubnet(var.ipblock, 5, count.index + 3 )

  tags        = {
    Name      = "CPFprivet-${count.index + 3}"
    Env       = terraform.workspace
    Date      = local.DateTime
    Env       = terraform.workspace
  }
}


##### public router table
resource "aws_route_table" "public-router" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
}
    tags = {
      Name = "Public Route Table CPF"
      Date = local.DateTime
      Env       = terraform.workspace
    }
 }


##### Associate route table########
  resource "aws_route_table_association" "public-router" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public-router.id
}

##### Elastic IP
resource "aws_eip" "eip" {

  depends_on = [aws_internet_gateway.gw]
  vpc        = true
 }


##### Privet router table
resource "aws_route_table" "privet-router" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
}
    tags = {
      Name = "Privet Route Table CPF"
      Date        = local.DateTime
      Env       = terraform.workspace
    }
 }



 #### Associate Privet route table
   resource "aws_route_table_association" "APR" {
   count          = 3
   subnet_id      = aws_subnet.privet[count.index].id
   route_table_id = aws_route_table.privet-router.id
 }


 #### Security Group
   resource "aws_security_group" "sg" {
     name        = "SG"
     description = "Allow TLS inbound traffic"
     vpc_id      = aws_vpc.main.id

     ingress {
       description      = "TLS from VPC"
       from_port        = 443
       to_port          = 443
       protocol         = "tcp"
       cidr_blocks      = [aws_vpc.main.cidr_block]
       ipv6_cidr_blocks = ["::/0"]
     }

     egress {
       from_port        = 0
       to_port          = 0
       protocol         = "-1"
       cidr_blocks      = ["0.0.0.0/0"]
       ipv6_cidr_blocks = ["::/0"]
     }
  tags = {
       Name = "allow_tls"
       Date = local.DateTime
       Env  = terraform.workspace
       }
     }
