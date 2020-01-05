echo ""
echo "Performing yum update"
echo ""
sudo yum check-update

echo ""
echo "Installing GIT"
echo ""
sudo yum -y install git

echo ""
echo "Installing docker"
echo ""
curl -fsSL https://get.docker.com/ | sh
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $(whoami)

echo ""
echo "Installing docker compose"
echo ""
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo ""
echo "Everything is done, please reboot"
echo ""