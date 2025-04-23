Overview

This guide explains how to set up a centralized logging stack using Promtail, Loki, and Grafana to monitor IPsec VPN logs in real-time. This architecture is designed to provide visibility into VPN tunnel status, connection errors, and handshakes, supporting scalable multi-client deployments.

  Step 1: Install Promtail

Promtail collects logs from /var/log/ and ships them to Loki.
    
    wget https://github.com/grafana/loki/releases/download/v2.9.3/promtail-linux-amd64.zip
    unzip promtail-linux-amd64.zip
    chmod +x promtail-linux-amd64
    sudo mv promtail-linux-amd64 /usr/local/bin/promtail

  Step 2: Configure Promtail

    Create /etc/promtail/promtail-config.yml
    
    server:
      http_listen_port: 9080
      grpc_listen_port: 0
    
    positions:
      filename: /tmp/positions.yaml
    
    clients:
      - url: http://localhost:3100/loki/api/v1/push
    
    scrape_configs:
      - job_name: ipsec-logs
        static_configs:
          - targets:
              - localhost
            labels:
              job: ipsec
              host: vpn-server
              __path__: /var/log/secure

  Step 3: Run Promtail as a Service

Create a systemd service unit:

    sudo nano /etc/systemd/system/promtail.service
    
    [Unit]
    Description=Promtail service
    After=network.target
    
    [Service]
    ExecStart=/usr/local/bin/promtail -config.file=/etc/promtail/promtail-config.yml
    Restart=always
    
    [Install]
    WantedBy=multi-user.target
    
    Enable and start:
    
    sudo systemctl daemon-reexec
    sudo systemctl enable promtail
    sudo systemctl start promtail

  Step 4: Install Loki (Log Aggregator)

    wget https://github.com/grafana/loki/releases/download/v2.9.3/loki-linux-amd64.zip
    unzip loki-linux-amd64.zip
    chmod +x loki-linux-amd64
    sudo mv loki-linux-amd64 /usr/local/bin/loki
    
    Step 5: Configure and Start Loki
    
    Create /etc/loki/loki-config.yml
    
    server:
      http_listen_port: 3100
    
    ingester:
      lifecycler:
        ring:
          kvstore:
            store: inmemory
          replication_factor: 1
      final_sleep: 0s
      chunk_idle_period: 5m
      max_chunk_age: 1h
    
    schema_config:
      configs:
        - from: 2020-10-15
          store: boltdb-shipper
          object_store: filesystem
          schema: v11
          index:
            prefix: index_
            period: 24h
    
    storage_config:
      boltdb_shipper:
        active_index_directory: /tmp/loki/index
        cache_location: /tmp/loki/boltdb-cache
      filesystem:
        directory: /tmp/loki/chunks
    
    limits_config:
      enforce_metric_name: false
      reject_old_samples: true
      reject_old_samples_max_age: 168h
    
    chunk_store_config:
      max_look_back_period: 0s
    
    compactor:
      working_directory: /tmp/loki/compactor
      shared_store: filesystem
    
    ruler:
      storage:
        type: local
        local:
          directory: /tmp/loki/rules

Create a service and enable:

    sudo nano /etc/systemd/system/loki.service
    
    [Unit]
    Description=Loki service
    After=network.target
    
    [Service]
    ExecStart=/usr/local/bin/loki -config.file=/etc/loki/loki-config.yml
    Restart=always
    
    [Install]
    WantedBy=multi-user.target
    
    Start the service:
    
    sudo systemctl daemon-reexec
    sudo systemctl enable loki
    sudo systemctl start loki

  Step 6: Connect Loki to Grafana

    In Grafana:
    
    Go to Settings > Data Sources
    
    Click Add data source
    
    Select Loki
    
    URL: http://localhost:3100
    
    Save & test

   Step 7: Create Grafana Panels with Aggregated Metrics

Once Loki is added as a data source in Grafana, create visual panels using the following LogQL queries with aggregation functions for real-time monitoring:

    Panel: Established Tunnels (per 5 minutes)
    
    Query:
    
    count_over_time({job="ipsec"} |= "established" [5m])
    
    Visualization: Time series line chart
    
    Y-axis: Number of connections
    
    Description: Shows how many tunnels were established every 5 minutes
  
    Panel: Closed Tunnels (per 5 minutes)
    
    Query:
    
    count_over_time({job="ipsec"} |= "closed" [5m])
    
    Visualization: Time series line chart
    
    Description: Tracks how many tunnels were closed in each 5-minute interval

    Panel: Proposal Failures (per 5 minutes)
    
    Query:
    
    count_over_time({job="ipsec"} |= "no proposal chosen" [5m])
    
    Visualization: Time series line chart
    
    Description: Tracks failed connections due to configuration mismatches

    Panel: Current Active Peers Estimate
    
    Query:
    
    count_over_time({job="ipsec"} |= "established" [1h]) - count_over_time({job="ipsec"} |= "closed" [1h])
    
    Visualization: Single stat or gauge
    
    Description: Provides an estimate of current active VPN tunnels

  Step 8: Configure Grafana Alerts (Optional)

    Set alerts to detect failures or abnormal patterns:
    
    Example: Alert if no new tunnels have been established in 10 minutes:
    
    count_over_time({job="ipsec"} |= "established" [10m]) == 0
    
    Condition: WHEN count() IS equal to 0
    
    Alert Frequency: Every 5 minutes
    
    Notification Channel: Email, Slack, or custom webhook

Notes

Ensure all logs are written to /var/log/secure on the VPN server

Use job, host, and instance labels for filtering by device/site

Rotate logs periodically to avoid storage overflow

Next Step: Proceed to docs/grafana-setup.md for dashboard export/import, multi-tenant filtering, and user access control.
