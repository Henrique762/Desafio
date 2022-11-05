#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install git -y
git clone https://github.com/Henrique762/Desafio.git
curl -fsSL https://get.docker.com -o get-docker.sh
DRY_RUN=1 sudo sh ./get-docker.sh
cd /Desafio/Projeto-Darede/Docker 
sudo docker swarm init
sudo docker stack deploy -c docker-compose.yaml sites


