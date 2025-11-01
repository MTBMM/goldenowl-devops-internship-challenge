#!/bin/bash
set -eux

# install docker
if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y docker.io
  systemctl enable --now docker
elif command -v yum >/dev/null 2>&1; then
  yum update -y
  amazon-linux-extras install -y docker
  systemctl enable --now docker
else
  echo "Unsupported package manager"
fi

# optional: add ubuntu/ec2-user to docker group
if id ubuntu >/dev/null 2>&1; then
  usermod -aG docker ubuntu || true
fi
if id ec2-user >/dev/null 2>&1; then
  usermod -aG docker ec2-user || true
fi

# pull and run container
DOCKER_IMAGE="${docker_image}"
APP_PORT="${app_port:-3000}"

# Wait for docker socket
for i in $(seq 1 10); do
  if docker --version >/dev/null 2>&1; then break; fi
  sleep 3
done

docker pull "${DOCKER_IMAGE}" || true

# run container (replace if exists)
if docker ps -a --format '{{.Names}}' | grep -q ^app-container$; then
  docker rm -f app-container || true
fi

docker run -d --name app-container -p ${APP_PORT}:${APP_PORT} --restart unless-stopped "${DOCKER_IMAGE}"
