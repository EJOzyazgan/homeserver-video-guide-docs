#!/bin/sh
#
# attach_containers_to_monitoring_net.sh
#
# Creates a monitoring network if it doesn’t exist and attaches
# selected containers with fixed aliases.

NET="monitoring-net"

# Check if network exists, else create it
if ! docker network ls --format '{{.Name}}' | grep -q "^${NET}$"; then
  echo "Creating docker network: ${NET}"
  docker network create "${NET}"
else
  echo "Docker network '${NET}' already exists"
fi

# List of containers and aliases (format: container_name:alias)
# Add services as needed. 
# I use an alias so if the cointainer name changes the Prometheus config does not need updating
containers="
ix-immich-server-1:immich-metrics
ix-prometheus-prometheus-1:prometheus-metrics
"

# Connect each container
for entry in $containers; do
  cname=$(echo "$entry" | cut -d: -f1)
  alias=$(echo "$entry" | cut -d: -f2)

  if docker ps --format '{{.Names}}' | grep -q "^${cname}$"; then
    echo "Attaching $cname to $NET with alias $alias"
    docker network connect --alias "$alias" "$NET" "$cname" 2>/dev/null || \
      echo "⚠️ $cname may already be connected to $NET"
  else
    echo "❌ Container $cname not found (is it running?)"
  fi
done

echo "✅ Done. Containers should now be reachable by aliases on ${NET}."
