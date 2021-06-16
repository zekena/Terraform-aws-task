# Terraform aws task

This task is made to install ec2 instance with ssh access on AWS

## Bucket and dynamodb
For changing the s3 bucket and dynamodb that are used for storing 
the state files and locks change the backend.hcl file and then run terraform init.

## Two key pairs are needed in order to setup the machine
By default two ssh key pairs are needed in order to Install the ec2 instance and connect to it
they can be changed by using the following variables public_key_path and private_key_path or generate two
key pairs with name Key and Key.pub in the root folder of the project by using ```ssh-keygen -t rsa```
