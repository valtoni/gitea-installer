#!/bin/bash

# Installed version
installed_version=$(/usr/local/bin/gitea --version | cut -f 3 -d " ")
installed_version_ma=$(echo $installed_version | cut -d'.' -f1) 
installed_version_mi=$(echo $installed_version | cut -d'.' -f2) 
installed_version_re=$(echo $installed_version | cut -d'.' -f3)

# Last released version
source ./gitea-download-url.sh
latest_version_ma=$(echo $gitea_latest_version | cut -d'.' -f1) 
latest_version_mi=$(echo $gitea_latest_version | cut -d'.' -f2) 
latest_version_re=$(echo $gitea_latest_version | cut -d'.' -f3)

# Verify if the released version is greatest than installed version
if [ $latest_version_ma -gt $installed_version_ma ] || 
   ([ $latest_version_ma -eq $installed_version_ma ] && [ $latest_version_mi -gt $installed_version_mi ]) || 
   ([ $latest_version_ma -eq $installed_version_ma ] && [ $latest_version_mi -eq $installed_version_mi ] && [ $latest_version_re -gt $installed_version_re ])
then
    echo "Current version: $installed_version, latest version: $gitea_latest_version. Upgrading..."
    # Stop gitea service 
    systemctl stop gitea
    # Backup current version
    gitea_bin="/usr/local/bin/gitea"
    gitea_backup="$gitea_bin-$(date +%Y%m%d%H%M%S)"
    mv $gitea_bin $gitea_backup
    # Get lastest version
    tmpfile=$(mktemp)
    wget -q $gitea_download_url_default -O $tmpfile
    chmod +x $tmpfile
    mv $tmpfile $gitea_bin 
    # Start gitea version
    systemctl start gitea
    # Show the backup location
    echo "Old version was placed in $gitea_backup"
else
    echo "The current version $installed_version is updated"
fi
