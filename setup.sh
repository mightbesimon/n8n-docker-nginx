apt update
apt install docker.io docker-compose nano nginx -y

echo ''
git clone https://github.com/mightbesimon/profile.bash.git
git -C profile.bash/ checkout stash
echo >> .profile
echo 'export PROFILE_256=1' >> .profile
echo 'export PROFILE=/root/profile.bash' >> .profile
echo 'source $PROFILE/profile.bash' >> .profile
source .profile

log info ''
git clone https://github.com/mightbesimon/n8n-docker-nginx.git
docker compose -f n8n-docker-nginx/docker-compose.yml up -d

ln -s /root/n8n-docker-nginx/n8n.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/n8n.conf /etc/nginx/sites-enabled/
ln -s /root/n8n-docker-nginx/status.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/status.conf /etc/nginx/sites-enabled/
nginx -s reload

command rm /etc/vector/vector.yaml
ln -s /root/n8n-docker-nginx/vector.yml /etc/vector/
systemctl restart vector

# # check status
# systemctl status docker nginx
# curl -I http://localhost:5678
# docker compose -f n8n-docker-nginx/docker-compose.yml ps
# docker compose -f n8n-docker-nginx/docker-compose.yml logs n8n
# # restarts
# systemctl restart nginx
# systemctl restart vector
