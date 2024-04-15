#!/bin/sh
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

echo 'to add user to docker group use sudo usermod -aG docker $USER or run as root'