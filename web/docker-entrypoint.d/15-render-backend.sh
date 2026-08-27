#!/bin/sh
# Extract actual IP of nameserver from /etc/resolv.conf (e.g. 10.217.0.1 or 127.0.0.11)
DNS_IP=$(awk '/nameserver/ {print $2; exit}' /etc/resolv.conf 2>/dev/null)
if [ -z "$DNS_IP" ]; then
  DNS_IP="1.1.1.1"
fi

echo "Setting Nginx resolver IP to: $DNS_IP 1.1.1.1"
sed -i "s|\${RESOLVER_IP}|$DNS_IP 1.1.1.1|g" /etc/nginx/templates/default.conf.template
