#!/usr/bin/env bash
REPO_CONF="/tmp/netdata.conf" #Update to initial copy location on your NAS
TARGET_CONF="/etc/netdata/netdata.conf"

if [ ! -f "$REPO_CONF" ]; then
  echo "Source config not found: $REPO_CONF"
  exit 1
fi

sudo cp "$REPO_CONF" "$TARGET_CONF"
sudo chown root:root "$TARGET_CONF"
sudo systemctl restart netdata
echo "netdata.conf applied and netdata restarted"
