resource "aws_instance" "ec2_tomcatOracleSample_oracle" {
  count = 1
  ami = "ami-759bc50a"
  instance_type = "t2.small"
  key_name = "${aws_key_pair.tomcatOracleSample_key_pair.key_name}"
  security_groups = ["${aws_security_group.tomcatOracleSample_oracle.name}"]
  provisioner "remote-exec" {
    connection {
      type = "ssh",
      user = "ubuntu",
      private_key = "${file("~/.ssh/id_rsa")}"
    }
    script = "terraformProvisionOracleUsingDocker.sh"
  }
  tags {
    Name = "tomcatOracleSample Oracle ${format("%03d", count.index)}"
  }
}