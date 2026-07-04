#!/bin/bash

echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/dont-prompt-$USER-for-sudo-password

echo start update system.
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y git unzip ca-certificates librabbitmq-dev libzip-dev gcc make git ca-certificates curl -y
sudo curl --insecure https://nexus.etalongroup.com/repository/public_crts/ca/RootCA.crt -o /usr/local/share/ca-certificates/RootCA.crt
sudo curl --insecure https://nexus.etalongroup.com/repository/public_crts/ca/SubCA.crt -o /usr/local/share/ca-certificates/SubCA.crt
sudo update-ca-certificates
echo install last version of PHP
sudo apt install -y php-cli php-zip php-pdo php-pgsql php-amqp  php-zip php-zip php-sockets php-mbstring php-curl php-xml php-bcmath php-intl php-gd php-xdebug
echo install last version of composer
sudo apt install composer -y
curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | sudo -E bash && sudo apt install symfony-cli

echo install docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -aG docker $USER
sudo systemctl start docker