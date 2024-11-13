#!/bin/bash

# Share the download gitea last github available version
gitea_latest_version=${1:-$(curl --silent "https://api.github.com/repos/go-gitea/gitea/releases/latest" | jq -r '.tag_name' 2>&1 | sed -e 's|.*-||' -e 's|^v||')}
gitea_download_url_default="https://github.com/go-gitea/gitea/releases/download/v${gitea_latest_version}/gitea-${gitea_latest_version}-linux-amd64"

export gitea_latest_version gitea_download_url_default