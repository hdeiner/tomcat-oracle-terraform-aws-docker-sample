resource "aws_security_group" "tomcatOracleSample_tomcat" {
  name = "tomcatOracleSample_tomcat"
  description = "tomcatOracleSample - SSH and Tomcat Access"
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = 8080
    to_port = 8080
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags {
    Name = "tomcatOracleSample Tomcat"
  }
}