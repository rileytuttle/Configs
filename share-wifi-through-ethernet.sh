#!/usr/bin/env bash

set -e

WAN_IF="$1"
LAN_IF="$2"
TS_IF="$3"

if [[ -z "$WAN_IF" || -z "$LAN_IF" || -z "$TS_IF" ]]; then
  echo "Usage: sudo $0 <WAN_IFACE> <LAN_IFACE> <TAILSCALE_IFACE>"
  exit 1
fi

CON_NAME="nm-shared-$LAN_IF"

echo "[+] WAN interface: $WAN_IF"
echo "[+] LAN interface: $LAN_IF"
echo "[+] Tailscale interface: $TS_IF"

# --- Create or reuse shared connection ---
if nmcli connection show "$CON_NAME" >/dev/null 2>&1; then
  echo "[+] Reusing existing connection $CON_NAME"
else
  echo "[+] Creating shared connection on $LAN_IF"
  nmcli connection add \
    type ethernet \
    ifname "$LAN_IF" \
    con-name "$CON_NAME" \
    ipv4.method shared
fi

echo "[+] Bringing up shared connection"
nmcli connection up "$CON_NAME"

# --- Wait for interface to get IP ---
echo "[+] Waiting for LAN IP..."
sleep 2

LAN_IP=$(ip -4 addr show "$LAN_IF" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1)

if [[ -z "$LAN_IP" ]]; then
  echo "[!] Failed to detect LAN IP"
  exit 1
fi

LAN_SUBNET=$(ip -4 route show dev "$LAN_IF" | grep -oP '\d+\.\d+\.\d+\.\d+/\d+')

echo "[+] LAN IP: $LAN_IP"
echo "[+] LAN subnet: $LAN_SUBNET"

# --- Enable IP forwarding (just in case) ---
echo "[+] Enabling IP forwarding"
sysctl -w net.ipv4.ip_forward=1 >/dev/null

# --- Add iptables rules (idempotent-ish) ---

add_rule() {
  if ! iptables -C "$@" 2>/dev/null; then
    iptables -A "$@"
  fi
}

echo "[+] Adding forwarding rules for LAN -> Tailscale"

# LAN → Tailscale
add_rule FORWARD -i "$LAN_IF" -o "$TS_IF" -j ACCEPT

# Return traffic
add_rule FORWARD -i "$TS_IF" -o "$LAN_IF" -m state --state ESTABLISHED,RELATED -j ACCEPT

echo "[+] Adding NAT for Tailscale"

add_rule -t nat POSTROUTING -o "$TS_IF" -j MASQUERADE

echo "[+] Setup complete"
echo ""
echo "Clients on $LAN_IF should now have:"
echo "  - Internet access (via $WAN_IF)"
echo "  - Tailnet access (via $TS_IF NAT)"
echo ""
echo "[i] Tailnet -> LAN is NOT enabled (intentional)"
echo "[i] To enable it later:"
echo "    sudo iptables -A FORWARD -i $TS_IF -o $LAN_IF -j ACCEPT"
echo "    sudo tailscale up --advertise-routes=$LAN_SUBNET"
