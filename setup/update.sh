#!/bin/sh

printf "%s" "Grafana admin password: "
read -sr admin_password

docker run --rm --add-host host.docker.internal:host-gateway -v "${PWD}/setup/grafana:/grafana" alpine/curl -s "http://host.docker.internal:3000/api/datasources" -u "admin:${admin_password}" -H 'Content-Type: application/json' --data-binary "@/grafana/datasource/prometheus.json"

docker run --rm --add-host host.docker.internal:host-gateway -v "${PWD}/setup/grafana:/grafana" alpine/curl -s "http://host.docker.internal:3000/api/datasources" -u "admin:${admin_password}" -H 'Content-Type: application/json' --data-binary "@/grafana/datasource/pyroscope.json"

docker run --rm --add-host host.docker.internal:host-gateway -v "${PWD}/setup/grafana:/grafana" alpine/curl -s "http://host.docker.internal:3000/api/datasources" -u "admin:${admin_password}" -H 'Content-Type: application/json' --data-binary "@/grafana/datasource/loki.json"

docker run --rm --add-host host.docker.internal:host-gateway -v "${PWD}/setup/grafana:/grafana" alpine/curl -s "http://host.docker.internal:3000/api/datasources" -u "admin:${admin_password}" -H 'Content-Type: application/json' --data-binary "@/grafana/datasource/tempo.json"

docker run --rm --add-host host.docker.internal:host-gateway -v "${PWD}/setup/grafana:/grafana" alpine/curl -s "http://host.docker.internal:3000/api/dashboards/db" -u "admin:${admin_password}" -H 'Content-Type: application/json' --data-binary "@/grafana/dashboard/docker.json"
