
#arm64 installing docker compose //

mkdir -p ~/.docker/cli-plugins/
curl -SL "https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-$(uname -s)-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

