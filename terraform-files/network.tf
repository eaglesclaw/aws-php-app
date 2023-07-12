resource "aws_vpc" "php_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Project VPC"
  }
}

resource "aws_subnet" "php_subnet" {
  vpc_id     = aws_vpc.php_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.php_vpc.id

  tags = {
    Name = "Project VPC IGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.php_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_assosiciation" {
  subnet_id      = aws_subnet.php_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "app_server_sg" {
  name        = "app-server-sg"
  description = "Security group for application servers"
  vpc_id      = aws_vpc.php_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "load_balancer_sg" {
  name        = "load-balancer-sg"
  description = "Security group for Load Balancer VM"
  vpc_id      = aws_vpc.php_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "mysql_server_sg" {
  name        = "mysql-server-sg"
  description = "Security group for MySQL server"
  vpc_id      = aws_vpc.php_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_server_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
