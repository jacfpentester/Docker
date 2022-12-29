#!/bin/bash
docker build -f Dockerfile_base -t ub-base .
docker build -f Dockerfile_nginx -t ub-nginx .
docker-compose -f ub_nginx.yml up -d
