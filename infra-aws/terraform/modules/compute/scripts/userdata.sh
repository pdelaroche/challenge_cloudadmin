#!/bin/bash

## Waiting for EC2 instance to be ready
sleep 45


# Update packages
apt-get update -y

# Add Docker's official GPG key:
apt-get update -y
apt-get install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

apt-get update -y

# Install Docker
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker
systemctl enable docker
systemctl start docker

# Add permision to generic ubuntu user
usermod -aG docker ubuntu

# Check docker version
docker version
docker compose version

#install awscli v2
snap install aws-cli --classic

#Install jq tool
apt install -y jq

#Secrets inyection
SECRET=$(aws secretsmanager get-secret-value \
  --secret-id dev/grafana-credentials \
  --region eu-west-1 \
  --output text \
  --query SecretString)  

GF_SECURITY_ADMIN_USER=$(echo $SECRET | jq -r .username) \
GF_SECURITY_ADMIN_PASSWORD=$(echo $SECRET | jq -r .password)