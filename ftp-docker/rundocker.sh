#!/bin/bash
docker build -f Dockerfile_base -t ub-base .
docker build -f Dockerfile_ftp -t ub-ftp .
docker-compose -f ub_ftp.yml up -d
