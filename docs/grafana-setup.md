Overview

This document covers the full setup, customization, and optimization of Grafana for visualizing VPN logs. It includes detailed instructions for creating dashboards, managing user access, organizing panels, filtering multi-tenant data, and setting up exportable templates and alerts.

Step 1: Install Grafana

    sudo dnf install https://dl.grafana.com/oss/release/grafana-10.0.0-1.x86_64.rpm -y
    sudo systemctl daemon-reexec
    sudo systemctl enable grafana-server
    sudo systemctl start grafana-server

    Access Grafana at http://<your-server-ip>:3000 (default credentials: admin/admin).

Step 2: Configure Basic Settings

    Change admin password upon first login
    
    Set the default organization name
    
    Enable anonymous access only if needed (not recommended for VPN dashboards)

Step 3: Add Loki as a Data Source

    Navigate to Configuration > Data Sources
    
    Click Add data source
    
    Select Loki
    
    Enter URL: http://localhost:3100
    
    Click Save & Test

Step 4: Build the IPsec VPN Dashboard

    Navigate to Create > Dashboard, then Add a new panel.
    
    Recommended Panels:
    
    Established Tunnels Over Time
    
    count_over_time({job="ipsec"} |= "established" [5m])
    
    Visualization: Time series chart
    
    Closed Tunnels
    
    count_over_time({job="ipsec"} |= "closed" [5m])
    
    Proposal Failures
    
    count_over_time({job="ipsec"} |= "no proposal chosen" [5m])
    
    Estimated Active Peers
    
    count_over_time({job="ipsec"} |= "established" [1h]) - count_over_time({job="ipsec"} |= "closed" [1h])

Step 5: Use Variables for Multi-Tenant Filtering

    Go to Dashboard Settings > Variables > New
    
    Name: host
    
    Type: Query
    
    Data source: Loki
    
    Query:
    
    label_values(host)
    
    Enable multi-value selection
    
    Apply host="$host" in each panel’s query to filter per MikroTik location.

Step 6: Organize Layout

    Group panels by purpose: Status, Errors, Peers
    
    Use horizontal row separators for visual clarity
    
    Name panels clearly (e.g., “Proposal Failures per 5m”)

Step 7: Save and Export Dashboard JSON

    Click Dashboard Settings > JSON Model
    
    Copy and save JSON into configs/grafana-dashboards/vpn-status-dashboard.json
    
    This allows restoring and sharing the dashboard

Step 8: Create Role-Based Access Control

    Recommended Roles:
    
    Admin: Full access
    
    Viewer: Read-only access
    
    Client: Filtered views with restricted variables
    
    To create users:
    
    Go to Server Admin > Users
    
    Add user, set org role
    
    Optional: Use Teams to group users with shared permissions

Step 9: Add Alerts for Critical Events

    Example: Alert if no proposal chosen appears >10 times in 5 minutes
    
    Panel Query:
    
    count_over_time({job="ipsec"} |= "no proposal chosen" [5m]) > 10
    
    Condition: WHEN last() IS ABOVE 10
    
    Alert every 5m
    
    Configure notification channels in Alerting > Contact points

Notes

Set dashboard refresh to 30s–1m for near real-time monitoring

Use folder-based dashboards to separate staging/prod or client-specific views

Restrict editing for Viewer roles to prevent config drift

Project Complete: The monitoring system is now fully operational. You can scale this to hundreds of MikroTik clients by adjusting Promtail paths and using labels per client/site.
