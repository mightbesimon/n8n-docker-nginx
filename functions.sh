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
	systemctl restart vector
}
function n8n_logs
{
	docker compose -f $HOME/n8n-docker-nginx/docker-compose.yml logs n8n
}
function status
{
	systemctl status docker nginx vector
	curl -I http://localhost:5678
	docker compose -f $HOME/n8n-docker-nginx/docker-compose.yml ps
}
