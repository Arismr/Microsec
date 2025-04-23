**/ Microsec /**

This repository provides a scalable, production-ready setup for managing and monitoring multiple dynamic MikroTik clients connected via IPsec VPN (strongSwan). It includes documentation, raw configs, setup scripts, and a Grafana dashboard for real-time log visualization.

**/ Features /**

Dynamic IPsec VPN (IKEv2 + PSK) with MikroTik compatibility

Centralized logging using Promtail + Loki

Real-time monitoring and alerting via Grafana

Scalable architecture for 50–1000+ remote clients

Log rotation and parsing scripts included

**/ Repository Structure /**

    .
    ├── configs/                     # Raw configurations and scripts
    │   ├── ipsec.conf              # strongSwan server config
    │   ├── ipsec.secrets           # Pre-shared keys
    │   ├── promtail-config.yml     # Promtail file target
    │   ├── loki-config.yml         # Loki backend config
    │   ├── grafana-dashboards/     # JSON-exported Grafana dashboards
    │   ├── mikrotik/               # MikroTik importable configs
    │   └── scripts/                # Shell and Python scripts for maintenance
    ├── docs/                       # Human-readable step-by-step setup guides
    ├── README.md                   # Project overview and usage

**/ Getting Started /**

Install all components:

    cd configs/scripts/
    ./install-stack.sh

Place your config files from configs/ into their appropriate system paths.

Set up MikroTik devices using sample-script.rsc or WebFig.

Start monitoring via Grafana at http://<server-ip>:3000

Import dashboard from grafana-dashboards/vpn-status-dashboard.json

**/ Log Maintenance /**

Use rotate-logs.sh via cron to archive and clean /var/log/secure

Use parse-logs.py to manually audit or test logs

**/ Alerts & Visualization /**

Alerting is configured in docs/alerts-config.md

Default Loki queries:

established, closed, no proposal chosen, AUTH_FAILED, timeouts

Custom dashboards with gauges and live feeds provided

**/ Security Notes /**

Do not commit real keys, IPs, or client-specific configs

Use fqdn (fully qualified domain names) for MikroTik scalability

All secrets and sensitive data are abstracted in this repo

**/ License /**
See LICENSE for terms.

**/ Contributions /**
Open PRs or issues for improvements. Community fixes welcome.

**/ Maintainer /**
This repository is maintained by [ArisMr].
