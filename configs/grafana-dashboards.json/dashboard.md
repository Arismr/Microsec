
**Purpose**

This file contains the full export of the IPsec VPN dashboard, including panels for established connections, tunnel closures, failures, and peer estimation. It can be imported into any Grafana instance.

Metadata (Sanitized)

UID: vpn-dashboard

Version: 1

Title: VPN Monitoring Dashboard

Panels:

Established Connections (logs)

Closed Connections (logs)

Timeout Gauge (graph from count_over_time)

Import Instructions

Open Grafana

Navigate to Dashboards > Import

Upload this JSON file or paste the contents

Link it to your Loki data source when prompted

File is expected to be version-controlled and updated as dashboard evolves. You can export from Grafana via Dashboard settings > JSON Model and replace contents here.
