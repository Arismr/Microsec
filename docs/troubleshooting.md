**Overview**

**This guide provides diagnostic tips and common fixes for problems related to IPsec VPN setup, MikroTik integration, logging stack errors, and Grafana visualization issues.*

**IPsec VPN Issues**

    Problem: Tunnel Not Establishing
    
    Check: Logs at /var/log/secure and sudo journalctl -u strongswan
    
    Fix: Ensure PSK matches on both sides and IKEv2 is selected
    
    Fix: Confirm server IP and subnet configuration in /etc/ipsec.conf
    
    Fix: Run ipsec statusall and check for errors like no proposal chosen

    Problem: Security Association Drops Immediately
    
    Fix: Verify dpdaction=clear and dpddelay, dpdtimeout values
    
    Fix: Ensure client-side NAT rule is bypassing VPN traffic

    Problem: Overlapping or Conflicting Subnets
    
    Fix: Use nat-traversal=yes in MikroTik peer config
    
    Fix: Set rightsubnet=%dynamic on the server if needed

**MikroTik-Specific Issues**

    Problem: MikroTik Not Connecting
    
    Check: /log print for connection attempts
    
    Fix: Use /ip ipsec installed-sa print and /ip ipsec active-peers print
    
    Fix: Ensure RouterOS time is synced using NTP

    Problem: Unexpected Disconnects
    
    Fix: Lower the rekey interval
    
    Fix: Ensure device clock and DPD timeout align with server

**Logging Stack Issues**
    
    Problem: Promtail Not Sending Logs
    
    Fix: Check Promtail logs with journalctl -u promtail
    
    Fix: Confirm file paths in /etc/promtail/promtail-config.yml
    
    Fix: Ensure target log file (e.g. /var/log/secure) exists and is updating

    Problem: Loki Not Receiving Logs
    
    Fix: Confirm Grafana can reach Loki at http://localhost:3100
    
    Fix: Verify service status: systemctl status loki
    
    Fix: Check Loki config file and port bindings

**Grafana Troubleshooting**

    Problem: No Logs Shown in Dashboard
    
    Fix: Validate data source settings in Configuration > Data Sources
    
    Fix: Adjust time window to “Last 1h” or “Last 6h” to find older logs
    
    Fix: Check for missing job or host labels in log entries

    Problem: Alert Not Firing
    
    Fix: Check if alert rule has a compatible query (count_over_time)
    
    Fix: Ensure contact point and notification policy are linked

    Problem: Dashboards Reset or Lost
    
    Fix: Export dashboards to JSON and commit to version control

**General Tips**

Always test configuration changes with one MikroTik before scaling

Use meaningful labels (host, site, client_id) for log filtering

Restart services after changes: ipsec, promtail, loki, grafana

Document all custom scripts and automation steps for repeatability
