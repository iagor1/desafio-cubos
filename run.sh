#!/bin/sh
terraform plan -out plan
terraform apply plan