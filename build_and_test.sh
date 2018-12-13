#!/usr/bin/env bash

# create the AWS EC2 test infrasctucture for Oracle
sed -i -r 's/count\s+\=\s+[0-9]+/count = 1/g' terraform/terraformResourceOracle.tf
sed -i -r 's/count\s+\=\s+[0-9]+/count = 0/g' terraform/terraformResourceTomcat.tf
cd terraform
terraform init
terraform apply -auto-approve
export ORACLE=$(echo `terraform output oracle_dns`)
cd ..

echo "Create database schema and load sample data"
# configure liquibase.properties to use the Oracle running in the AWS EC2 instance just created
sed -i -r 's/^url\:\ .*$/url: jdbc:oracle:thin:@'$ORACLE':1521:xe/g' liquibase.properties
liquibase --changeLogFile=src/main/db/changelog.xml update

# configure the war we are about to build and bake in the ORACLE dns endpoint
sed -i -r 's/^url\=.*$/url=jdbc:oracle:thin:@'$ORACLE':1521\/xe/g' oracleConfig.properties

echo "Build fresh war for Tomcat deployment"
mvn clean compile war:war

# create the test infrasctucture for Tomcat
sed -i -r 's/count\s+\=\s+[0-9]+/count = 1/g' terraform/terraformResourceOracle.tf
sed -i -r 's/count\s+\=\s+[0-9]+/count = 1/g' terraform/terraformResourceTomcat.tf
cd terraform
terraform apply -auto-approve
export TOMCAT=$(echo `terraform output tomcat_dns`)
cd ..

echo Running smoke test...
echo "Running smoke test on "$TOMCAT
curl -s $TOMCAT:8080/passwordAPI/passwordDB > temp
if grep -q "RESULT_SET" temp
then
    echo "SMOKE TEST SUCCESS"

    echo "Run integration tests"
    sed -i -r 's/^hosturl\=.*$/hosturl=http\:\/\/'$TOMCAT':8080/g' rest_webservice.properties
    mvn verify failsafe:integration-test

    echo "Bring down everything we created"
    cd terraform
    terraform destroy -auto-approve
    cd ..
else
    echo "SMOKE TEST FAILURE!!!"
fi
rm temp