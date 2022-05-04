#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
cd /var/www/html
echo "<html><body><h1>Hello from $(hostname -f)!</h1><h3>My name is Elmer Almeida. Student number: 991507719.</h3></body></html>" > index.html
systemctl restart httpd
systemctl enable httpd
