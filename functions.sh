#!/bin/bash

function reload_docker
{
	docker compose -f $HOME/n8n-docker-nginx/docker-compose.yml down
	docker compose -f $HOME/n8n-docker-nginx/docker-compose.yml up --force-recreate --build -d
}
function reload_nginx
{
	nginx -s reload
}
function reload_vector
{
	cp $HOME/n8n-docker-nginx/vector.yaml /etc/vector/
	systemctl restart vector
}
function show_logs
{
	docker compose -f $HOME/n8n-docker-nginx/docker-compose.yml logs n8n --tail 100
}
function show_status
{
	systemctl is-active nginx > /dev/null \
	&& log info  'nginx is active' \
	|| log error 'nginx is inactive'
	docker compose -f $HOME/n8n-docker-nginx/docker-compose.yml ps | grep n8n | grep Up > /dev/null \
	&& log info  'n8n container is up' \
	|| log error 'n8n container is down'
	curl -I http://localhost:5678/healthz > /dev/null \
	&& log info  'n8n is reachable' \
	|| log error 'n8n is unreachable'
	systemctl is-active vector > /dev/null \
	&& log info  'metrics is active' \
	|| log error 'metrics is inactive'
}
function pull
{
	git -C $HOME/profile.bash/ pull --rebase \
	&& log info  'profile repo updated' \
	|| log error 'profile repo failed to pull'
	git -C $HOME/n8n-docker-nginx/ pull --rebase \
	&& log info  'n8n repo updated' \
	|| log error 'n8n repo failed to pull'
	source $HOME/.profile
}
