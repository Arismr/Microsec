**Overview**

This guide details how to configure alerting in Grafana using Loki as the data source. Alerts notify administrators of VPN failures, tunnel instability, configuration mismatches, and inactivity. Proper alerting improves response time and service reliability.

**Step 1: Understand Loki-Based Alerting in Grafana**

Grafana’s alert engine supports LogQL expressions from Loki, but only numeric expressions (like count_over_time) can trigger alerts.

Ensure that:

    Loki is connected as a data source
    
    Panels use queries compatible with alerting
    
    Alert evaluation is set for 1m–5m intervals depending on sensitivity

**Step 2: Set Up Contact Points (Notifications)**

    Go to Alerting > Contact points
    
    Click New contact point
    
    Choose type (Email, Slack, Webhook, Telegram, etc.)
    
    Add integration details
    
    Test the notification

**Step 3: Create Notification Policies**

    Go to Alerting > Notification policies
    
    Add a default route that uses the contact point
    
    Use filtering if you want different alerts to go to different teams
    
    Step 4: Define Common Alert Rules

    1. No Tunnels Established
    
    Detect if no VPN tunnels are established within a 10-minute window.
    
    count_over_time({job="ipsec"} |= "established" [10m]) == 0
    
    Trigger: WHEN last() IS EQUAL TO 0
    
    Frequency: Every 5m

    2. Spike in Proposal Failures
    
    Detect misconfigurations or attacks by counting "no proposal chosen" events.
    
    count_over_time({job="ipsec"} |= "no proposal chosen" [5m]) > 10
    
    Trigger: WHEN last() IS ABOVE 10
    
    Frequency: Every 5m

    3. Tunnel Flapping
    
    Detect high numbers of disconnects indicating instability.
    
    count_over_time({job="ipsec"} |= "closed" [5m]) > 20
    
    Trigger: WHEN last() IS ABOVE 20
    
    Frequency: Every 5m

**Step 5: Link Alerts to Panels**

    Edit any relevant panel (e.g., “Tunnel Failures per 5m”)
    
    Click Alert > Create alert rule
    
    Set query to LogQL with aggregation
    
    Define the condition and threshold
    
    Link to a contact point and save

**Step 6: Test and Validate**

    Use logger or simulate VPN events to generate logs
    
    Watch for triggers in Alerting > Alert Rules
    
    Confirm alerts show up under Alert History
    
    Check delivery to the correct contact point

**Step 7: Recommended Alert Hygiene**

    Do not over-alert (avoid alert fatigue)
    
    Use different severity levels (warning vs. critical)
    
    Clearly name alerts with context (e.g., "[VPN] No New Connections")
    
    Set reminder intervals if the alert remains active
    
    Use annotations in Grafana dashboards to correlate with time-based events

**Notes**

Alerting works best with time-series queries that aggregate log data

Raw log searches (|=) without aggregation cannot trigger alerts

Use dashboards to visually confirm alert patterns before enabling notifications

Next: Build a dashboard export/import routine and automate dashboard deployment through provisioning (if desired).
