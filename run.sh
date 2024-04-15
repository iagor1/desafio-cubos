#!/bin/sh
terraform init
terraform plan -out plan
terraform apply plan