/ip ipsec proposal
add name=strongswan-proposal auth-algorithms=sha256 enc-algorithms=aes-256-cbc pfs-group=modp1024

/ip ipsec peer
add name=vpn-peer address=<vpn-server-ip> exchange-mode=ike2 secret="<shared-key>" send-initial-contact=yes policy-template-group=default proposal-check=obey nat-traversal=yes

/ip ipsec identity
add peer=vpn-peer auth-method=pre-shared-key secret="<shared-key>"

/ip ipsec policy group
add name=default

/ip ipsec policy
add src-address=0.0.0.0/0 dst-address=<vpn-server-subnet> sa-dst-address=<vpn-server-ip> tunnel=yes action=encrypt level=require proposal=strongswan-proposal

/ip firewall nat
add chain=srcnat dst-address=<vpn-server-subnet> action=accept


Replace <vpn-server-ip>, <vpn-server-subnet>, and <shared-key> with appropriate values per deployment.
