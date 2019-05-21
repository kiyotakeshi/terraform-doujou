# --------
# ec2 instance
resource "aws_instance" "doujou01" {
  ami                    = "ami-0f9ae750e8274075b"                 # tokyo
  instance_type          = "${var.WEB_SERVER_INSTANCE_TYPE}"
  subnet_id              = "${aws_subnet.public_0.id}"
  vpc_security_group_ids = ["${aws_security_group.doujou_ec2.id}"]
  key_name               = "${var.PEM_FILE_WEBSERVERS}"

  # install of apache
  # user_data = "${file("${var.PLATFORM == "WIN" ? var.WIN_PATH : var.UNIX_PATH}")}"

  user_data = <<EOF
  #!/bin/bash


  yum install php php-mysql php-gd php-mbstring -y
  yum install mysql -y
  wget -O /tmp/wordpress-4.9.4-ja.tar.gz https://ja.wordpress.org/wordpress-4.9.4-ja.tar.gz
  cd /tmp
  tar zxf wordpress-4.9.4-ja.tar.gz
  mv wordpress /var/www/html
  chown -R apache:apache /var/www/html
  systemctl enable httpd
  systemctl start httpd
  export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
  echo "<html><body><h1>Hello from Production Backend at instance <b>"$INSTANCE_ID"</b></h1></body></html>" > /var/www/html/index.html

  EOF
  root_block_device = {
    volume_type = "gp2"
    volume_size = "8"
  }
  ebs_block_device = {
    device_name = "/dev/sdf"
    volume_type = "gp2"
    volume_size = "8"
  }
  tags {
    Name = "${var.PROJECT_NAME}-instance-01"
  }
}

resource "aws_instance" "doujou02" {
  ami                    = "ami-0f9ae750e8274075b"
  instance_type          = "${var.WEB_SERVER_INSTANCE_TYPE}"
  subnet_id              = "${aws_subnet.public_1.id}"
  vpc_security_group_ids = ["${aws_security_group.doujou_ec2.id}"]
  key_name               = "${var.PEM_FILE_WEBSERVERS}"

  # install of apache
  # user_data = "${file("${var.PLATFORM == "WIN" ? var.WIN_PATH : var.UNIX_PATH}")}"

  user_data = <<EOF
  #!/bin/bash


  yum install php php-mysql php-gd php-mbstring -y
  yum install mysql -y
  wget -O /tmp/wordpress-4.9.4-ja.tar.gz https://ja.wordpress.org/wordpress-4.9.4-ja.tar.gz
  cd /tmp
  tar zxf wordpress-4.9.4-ja.tar.gz
  mv wordpress /var/www/html
  chown -R apache:apache /var/www/html
  systemctl enable httpd
  systemctl start httpd
  export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
  echo "<html><body><h1>Hello from Production Backend at instance <b>"$INSTANCE_ID"</b></h1></body></html>" > /var/www/html/index.html


  EOF
  root_block_device = {
    volume_type = "gp2"
    volume_size = "8"
  }
  ebs_block_device = {
    device_name = "/dev/sdf"
    volume_type = "gp2"
    volume_size = "8"
  }
  tags {
    Name = "${var.PROJECT_NAME}-instance-02"
  }
}
