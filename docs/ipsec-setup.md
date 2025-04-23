Overview

This document is a comprehensive guide to setting up an IPsec VPN using strongSwan on Rocky Linux and connecting it with multiple MikroTik clients using IKEv2 with Pre-Shared Key (PSK) authentication. This guide is built for scalability, dynamic clients, and seamless logging/monitoring integration with tools like Promtail, Loki, and Grafana.

Step 1: Install strongSwan on Rocky Linux

    sudo dnf install epel-release -y
    sudo dnf install strongswan -y

Enable and start the service:

    sudo systemctl enable strongswan
    sudo systemctl start strongswan

Step 2: Create /etc/ipsec.conf

This file controls the IPsec VPN connection setup.

    config setup
        charondebug="ike 2, knl 2, cfg 2"
    
    conn mikrotik-dynamic
        keyexchange=ikev2
        ike=aes256-sha256-modp1024!
        esp=aes256-sha256!
        dpdaction=clear
        dpddelay=30s
        dpdtimeout=120s
        rekey=no
        left=<server-public-ip>
        leftid=<server-public-ip>
        leftsubnet=<internal-subnet>
        right=%any
        rightid=%any
        rightsubnet=%any
        authby=secret
        auto=add
        keyingtries=%forever
        fragmentation=yes



Explanation:

left is the VPN server IP

right=%any allows connections from dynamic MikroTik clients

keyingtries=%forever ensures tunnel retries indefinitely

fragmentation=yes mitigates UDP fragmentation issues

Step 3: Set Shared Secret in /etc/ipsec.secrets

%any %any : PSK "your-secret-key"

Use a strong, complex pre-shared key.

Step 4: Allow Required Firewall Ports

    sudo firewall-cmd --add-service="ipsec" --permanent
    sudo firewall-cmd --add-port=500/udp --permanent
    sudo firewall-cmd --add-port=4500/udp --permanent
    sudo firewall-cmd --reload

Also allow UDP 500 and 4500 through any cloud firewall or hosting environment settings.

Step 5: Enable IP Forwarding

    echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p

Step 6: Test and Restart strongSwan

    sudo ipsec restart
    sudo ipsec statusall

Check logs:

    sudo journalctl -u strongswan

Result

The VPN server is now configured and ready to accept dynamic MikroTik clients. Upon successful tunnel negotiation, clients will have access to the specified internal subnet.

Notes

Use ip xfrm state to verify active security associations

Logs can be forwarded using Promtail to a Loki instance, then visualized in Grafana

This configuration supports scaling to hundreds of clients with minimal overhead

Next Step: Proceed to docs/mikrotik-config.md to configure the client side.
