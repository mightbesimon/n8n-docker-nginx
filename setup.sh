#!/bin/bash
startms=$(date +%s%3N)

################################################################################
apt update
apt install docker.io docker-compose nano nginx -y
elapsed=$(( $(date +%s%3N) - startms ))
echo $((elapsed / 60000))m $(((elapsed % 60000) / 1000)).$((elapsed % 100))s

################################################################################
git clone https://github.com/mightbesimon/profile.bash.git
git -C profile.bash/ checkout stash
echo >> .profile
echo 'export PROFILE_256=1' >> .profile
echo "export PROFILE=$HOME/profile.bash" >> .profile
echo 'source $PROFILE/profile.bash' >> .profile
source .profile
log info 'profile setup complete'

################################################################################
git clone https://github.com/mightbesimon/n8n-docker-nginx.git
docker compose -f n8n-docker-nginx/docker-compose.yml up -d
log info 'n8n docker setup complete'

################################################################################
ln -s $HOME/n8n-docker-nginx/n8n.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/n8n.conf /etc/nginx/sites-enabled/
ln -s $HOME/n8n-docker-nginx/status.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/status.conf /etc/nginx/sites-enabled/
nginx -s reload
log info 'nginx reverse proxy setup complete'

################################################################################
cp $HOME/n8n-docker-nginx/vector.yaml /etc/vector/
curl --proto '=https' --tlsv1.2 -sSfL https://sh.vector.dev | bash -s -- -y
usermod -a -G docker vector
systemctl restart vector
log info 'vector observability setup complete'

################################################################################
echo "source $HOME/n8n-docker-nginx/functions.sh" >> .profile
source n8n-docker-nginx/functions.sh
log info 'utility functions loaded'

################################################################################
elapsed=$(( $(date +%s%3N) - startms ))
echo -n $FAINT$((elapsed / 60000))m $(((elapsed % 60000) / 1000)).$((elapsed % 100))s
log info finished setup
