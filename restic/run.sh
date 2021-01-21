#!/usr/bin/with-contenv bashio
echo "HassOS restic add-on starting"
date
set -x

mkdir -p /data/restic-cache

# load configuration
CONFIG_PATH=/data/options.json

$(jq -r '.env_vars|to_entries[]|"export " + .key + "=" + (.value|tostring) + ""' "$CONFIG_PATH")
jq -r '.exclude_patterns[]|.' "$CONFIG_PATH" > /exclude_file

restic version
restic stats

# run the backup
restic \
  --cache-dir=/data/restic-cache \
  --verbose \
  --exclude-file=/exclude_file \
  backup           \
      /backup/      \
      /ssl/         \
      /config/


echo "Done"
