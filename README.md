# Docker Monitoring

A comprehensive Docker monitoring solution that combines Grafana with multiple observability tools to provide complete visibility into your Docker environments.

## Overview

This project sets up a monitoring stack for Docker environments using:

- **[Grafana](https://grafana.com)**: Visualization and dashboarding
- **[Prometheus](https://prometheus.io)**: Metrics collection and storage
- **[Loki](https://grafana.com/oss/loki)**: Log storage
- **[Tempo](https://grafana.com/oss/tempo)**: Tracing collection and storage
- **[Pyroscope](https://grafana.com/oss/pyroscope)**: Continuous profiling
- **[Alloy](https://grafana.com/oss/alloy-opentelemetry-collector)**: Log collection
- **[Docker Exporter](https://hub.docker.com/r/blackprism/docker-exporter)**: Custom exporter for Docker metrics

## Prerequisites

- Docker and Docker Compose installed
- Basic understanding of Docker and monitoring concepts

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/docker-monitoring.git
   cd docker-monitoring
   ```

2. Start the monitoring stack:
   ```bash
   docker network create docker-monitoring_public
   docker-compose up -d
   ```

3. Initialize Grafana with data sources and dashboards:
   ```bash
   chmod a+x setup/init.sh
   ./setup/init.sh
   ```

4. Access Grafana at http://localhost:3000 (default credentials: admin/admin)

## External Service Monitoring

This monitoring stack can be configured to scrape metrics from external services running in other Docker Compose projects.

### Configuration Steps

1. Ensure your external service is connected to this network:
   ```yaml
   # In your external service's docker-compose.yml
   services:
    my-external-service:
      image: example.org/my-external-service 
      networks:
        - default
        - docker-monitoring_public

   networks:
     docker-monitoring_public:
       external: true
   ```

2. Configure the scrape settings for your service:
   ```yaml
   # config/prometheus/external_service/my-external-service.yml
   scrape_configs:
     - job_name: "my-external-service"
       scrape_interval: 15s
       scrape_timeout: 10s

       static_configs:
         - targets: ["my-external-service.docker-monitoring_public:9100"]
   ```

   The target format follows the Docker DNS pattern: 
   ```
   [container-name].docker-monitoring_public:[port]
   ```

   You can find the exact name of your container with the command:
   ```bash
   docker ps --format '{{.Names}}'
   ```

3. Restart Prometheus to load the new configuration:
   ```bash
   docker compose restart prometheus
   ```

### Troubleshooting External Service Monitoring

If you're having trouble with external service monitoring:

1. Verify network connectivity:
   ```bash
   docker run --rm --network docker-monitoring_public alpine ping my-external-service.docker-monitoring_public
   ```

2. Check if the metrics endpoint is accessible:
   ```bash
   docker run --rm --network docker-monitoring_public alpine/curl -v my-external-service.docker-monitoring_public:9100/metrics
   ```
