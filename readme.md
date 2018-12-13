This project demomstrates a way to build and test on AWS EC2 between an Oracle database and a Tomcat application.

* Terraform create the AWS EC2 instances for an Oracle server
* Fix Liquibase properties to point to the Oracle instance
* Create the schema and test data in Oracle through Liquibase
* Fix Tomcat properties to point to the Oracle instance 
* Create the Tomcat war that we want to test
* Terraform create the AWS EC2 instances for a Tomcat server (provisioning the war and the configuration in the same step)
* Run quick smoke test 
* Run extensive cucumber based integration tests from build script
* Destroy the AWS EC2 instances