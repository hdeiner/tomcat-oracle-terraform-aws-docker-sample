resource "aws_instance" "ec2_tomcatOracleSample_tomcat" {
  count = 1
  ami = "ami-759bc50a"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.tomcatOracleSample_key_pair.key_name}"
  security_groups = ["${aws_security_group.tomcatOracleSample_tomcat.name}"]
  provisioner "file" {
    connection {
      type = "ssh",
      user = "ubuntu",
      private_key = "${file("~/.ssh/id_rsa")}"
    }
    source      = "../target/passwordAPI.war"
    destination = "/home/ubuntu/passwordAPI.war"
  }
  provisioner "file" {
    connection {
      type = "ssh",
      user = "ubuntu",
      private_key = "${file("~/.ssh/id_rsa")}"
    }
    source      = "../oracleConfig.properties"
    destination = "/home/ubuntu/oracleConfig.properties"
  }
  provisioner "remote-exec" {
    connection {
      type = "ssh",
      user = "ubuntu",
      private_key = "${file("~/.ssh/id_rsa")}"
    }
    script = "terraformProvisionTomcatUsingDocker.sh"
  }
  tags {
    Name = "tomcatOracleSample Tomcat ${format("%03d", count.index)}"
  }
}
