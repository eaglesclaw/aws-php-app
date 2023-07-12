resource "aws_instance" "app_servers" {
  count         = 2
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id     = aws_subnet.php_subnet.id
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]
  key_name = "projectkeypair"

  user_data = "${file("install_app.sh")}"
}

resource "aws_instance" "load_balancer" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.php_subnet.id
  key_name = "projectkeypair"
  associate_public_ip_address = true
  tags = {

    Name = "LB Server"
  }
  vpc_security_group_ids = [aws_security_group.load_balancer_sg.id]

  user_data = "${file("install_lb.sh")}"

}

resource "aws_instance" "mysql_server" {
  ami           = "ami-053b0d53c279acc90" # Ubuntu AMI'ı buraya girin
  instance_type = "t2.micro"
  key_name = "projectkeypair"
  associate_public_ip_address = true
  subnet_id     = aws_subnet.php_subnet.id
  tags = {

    Name = "SQL Server"
  }

  vpc_security_group_ids = [aws_security_group.mysql_server_sg.id]

  user_data = "${file("install_mysql.sh")}"
}
