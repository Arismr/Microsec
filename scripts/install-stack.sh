Purpose

This script installs and configures strongSwan, Promtail, Loki, and Grafana in one go. It's intended for fresh Rocky Linux deployments.

**Script Content**
----------------------------------------------------------------------------------
    #!/bin/bash
    
    set -e
    
    # Update and install prerequisites
    echo "[+] Installing dependencies"
    sudo dnf install -y epel-release unzip curl wget vim
    
    # Install strongSwan
    sudo dnf install -y strongswan
    sudo systemctl enable strongswan
    sudo systemctl start strongswan
    
    # Install Promtail
    echo "[+] Installing Promtail"
    wget -q https://github.com/grafana/loki/releases/download/v2.9.3/promtail-linux-amd64.zip
    unzip promtail-linux-amd64.zip
    chmod +x promtail-linux-amd64
    sudo mv promtail-linux-amd64 /usr/local/bin/promtail
    
    # Install Loki
    echo "[+] Installing Loki"
    wget -q https://github.com/grafana/loki/releases/download/v2.9.3/loki-linux-amd64.zip
    unzip loki-linux-amd64.zip
    chmod +x loki-linux-amd64
    sudo mv loki-linux-amd64 /usr/local/bin/loki
    
    # Install Grafana
    echo "[+] Installing Grafana"
    sudo dnf install -y https://dl.grafana.com/oss/release/grafana-10.0.0-1.x86_64.rpm
    sudo systemctl enable grafana-server
    sudo systemctl start grafana-server
    
    # Summary
    echo "[+] Done. Configure your .conf and .yml files manually."
    echo "Access Grafana via: http://<your-server-ip>:3000"
----------------------------------------------------------------------------------
**Usage**
----------------------------------------------------------------------------------
chmod +x install-stack.sh
./install-stack.sh
----------------------------------------------------------------------------------
After running this script, configure each service by placing the appropriate files from configs/ into place and enabling their respective systemd services.


