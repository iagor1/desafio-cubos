#!/bin/sh
echo "baixando binario do terraform amd64, caso esteja usando outra arquitetura mude o link"
cd ~
curl -O https://releases.hashicorp.com/terraform/1.8.0/terraform_1.8.0_linux_amd64.zip
unzip terraform_1.8.0_linux_amd64.zip
./terraform --version

#link arm64 : https://releases.hashicorp.com/terraform/1.8.0/terraform_1.8.0_linux_arm64.zip
#link arm : https://releases.hashicorp.com/terraform/1.8.0/terraform_1.8.0_linux_arm.zip
#link 386 : https://releases.hashicorp.com/terraform/1.8.0/terraform_1.8.0_linux_386.zip
#link windows amd64 : https://releases.hashicorp.com/terraform/1.8.0/terraform_1.8.0_windows_amd64.zip
