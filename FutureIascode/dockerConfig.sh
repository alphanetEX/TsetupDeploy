#!/bin/bash
RELEASE_URL=https://api.github.com/repos/docker/compose-cli/releases/latest
DOWNLOAD_URL=${DOWNLOAD_URL:-$(curl -s ${RELEASE_URL} | grep "browser_download_url.*docker-linux-arm64" | cut -d : -f 2,3)}

#arm64 installing docker compose //
mkdir -p ~/.docker/cli-plugins/
curl -SL "https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-$(uname -s)-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
