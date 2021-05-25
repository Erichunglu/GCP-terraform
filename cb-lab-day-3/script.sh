#!/bin/bash
sudo yum -y install httpd
sudo yum -y install awscli
sudo systemctl start httpd && sudo systemctl enable httpd
#echo '<h1><center>This is our Cathay Bootcamp Website</center></h1>' > index.html
#sudo mv index.html /var/www/html/
#BUCKET_URL= https://s3.amazonaws.com/eric.fun

sudo aws s3 cp s3://eric.fun/index.html /var/www/html/

sudo yum -y install docker
sudo systemctl start docker
sudo docker login quay.io -u klteric1 -p eric12345
sudo docker pull quay.io/klteric1/vuejs_app2
sudo docker run -d -p 8080:8080 quay.io/klteric1/vuejs_app2:latest