Overview

This document provides a step-by-step guide for configuring MikroTik RouterOS devices to connect to an IPsec VPN server using IKEv2 with Pre-Shared Key (PSK) authentication. This setup is designed to be scalable and compatible with strongSwan.

Prerequisites

-MikroTik device running RouterOS version 6.45 or later

-VPN server already configured (refer to ``)

-Pre-Shared Key provided by the VPN administrator

  Step 1: Create an IPsec Proposal

This defines the encryption and authentication algorithms to use.

    /ip ipsec proposal add \
        name=strongswan-proposal \
        auth-algorithms=sha256 \
        enc-algorithms=aes-256-cbc \
        pfs-group=modp1024

  Step 2: Define the VPN Peer

This tells the MikroTik where the VPN server is located and what protocol to use.

    /ip ipsec peer add \
        name=vpn-peer \
        address=<vpn-server-ip> \
        exchange-mode=ike2 \
        secret="<shared-key>" \
        send-initial-contact=yes \
        policy-template-group=default \
        proposal-check=obey \
        nat-traversal=yes
    
    Important: nat-traversal=yes allows connections from MikroTik devices behind NAT. It also helps support scalability when clients use overlapping or identical subnets.

Replace <vpn-server-ip> with the IP of the VPN server and <shared-key> with the actual shared secret.

  Step 3: Create Identity

This defines how the MikroTik authenticates to the VPN server.

    /ip ipsec identity add \
        peer=vpn-peer \
        auth-method=pre-shared-key \
        secret="<shared-key>"

  Step 4: Define Policy Group (Optional but Recommended)

Used to group multiple dynamic policies.

    /ip ipsec policy group add name=default

  Step 5: Add IPsec Policy

This controls what traffic gets encrypted.

    /ip ipsec policy add \
        src-address=0.0.0.0/0 \
        dst-address=<vpn-server-subnet> \
        sa-dst-address=<vpn-server-ip> \
        tunnel=yes \
        action=encrypt \
        level=require \
        proposal=strongswan-proposal

Replace <vpn-server-subnet> with the internal subnet behind the VPN server.

  Step 6: Add NAT Bypass Rule

This prevents the router from NAT'ing VPN traffic.
  
    /ip firewall nat add \
        chain=srcnat \
        dst-address=<vpn-server-subnet> \
        action=accept

  Step 7: Enable IPsec

Ensure the IPsec service is running:

    /ip ipsec enable

  Step 8: Verify Tunnel Status

Monitor the tunnel connection:
    
    /ip ipsec active-peers print
    /ip ipsec installed-sa print

You should see a successful connection with Security Associations (SAs) established.

  Notes

Ensure system clock is synced via NTP to avoid IKEv2 failures

If no connection forms, use /log print to debug

Match encryption/auth algorithms with server exactly

nat-traversal=yes is required for clients behind NAT or with conflicting subnets to ensure seamless scaling across many locations

Next Step: Review docs/logging-stack.md for integrating logging and visualization.


