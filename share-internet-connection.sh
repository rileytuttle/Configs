#!/usr/bin/env bash

set -e

WAN_IF="$1"
LAN_IF="$2"
TS_IF="$3"
MODE="$4"

if [[ -z "$WAN_IF" || -z "$LAN_IF" || -z "$TS_IF" ]]; then
  echo "Usage: sudo $0 <WAN_IFACE> <LAN_IFACE> <TAILSCALE_IFACE> [--wifi]"
  exit 1
fi

CON_NAME="nm-shared-$LAN_IF"

echo "[+] WAN interface: $WAN_IF"
echo "[+] LAN interface: $LAN_IF"
echo "[+] Tailscale interface: $TS_IF"

# --- Determine if LAN is WiFi ---
IS_WIFI=false
if [[ "$MODE" == "--wifi" ]]; then
  IS_WIFI=true
fi

# --- Create or reuse connection ---
if nmcli connection show "$CON_NAME" >/dev/null 2>&1; then
  echo "[+] Reusing existing connection $CON_NAME"
else
  echo "[+] Creating shared connection on $LAN_IF"

  if $IS_WIFI; then
    echo "[+] Configuring WiFi AP mode"

    nmcli connection add \
      type wifi \
      ifname "$LAN_IF" \
      con-name "$CON_NAME" \
      autoconnect yes \
      ssid "SharedNet" \
      802-11-wireless.mode ap \
      802-11-wireless.band bg \
      ipv4.method shared

    nmcli connection modify "$CON_NAME" \
      wifi-sec.key-mgmt wpa-psk \
      wifi-sec.psk "password123"

  else
    nmcli connection add \
      type ethernet \
      ifname "$LAN_IF" \
      con-name "$CON_NAME" \
      ipv4.method shared
  fi
fi

echo "[+] Bringing up shared connection"
nmcli connection up "$CON_NAME"

# --- Wait for IP ---
echo "[+] Waiting for LAN IP..."
sleep 3

LAN_IP=$(ip -4 addr show "$LAN_IF" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1)
LAN_SUBNET=$(ip -4 route show dev "$LAN_IF" | grep -oP '\d+\.\d+\.\d+\.\d+/\d+')

if [[ -z "$LAN_IP" ]]; then
  echo "[!] Failed to detect LAN IP"
  exit 1
fi

echo "[+] LAN IP: $LAN_IP"
echo "[+] LAN subnet: $LAN_SUBNET"

# --- Enable forwarding ---
echo "[+] Enabling IP forwarding"
sysctl -w net.ipv4.ip_forward=1 >/dev/null

# --- Helper to avoid duplicate rules ---
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

echo ""
echo "[+] Setup complete"
echo ""

if $IS_WIFI; then
  echo "📡 WiFi AP details:"
  echo "  SSID: SharedNet"
  echo "  Password: password123"
fi

echo "Clients on $LAN_IF now have:"
echo "  ✅ Internet via $WAN_IF"
echo "  ✅ Tailnet via $TS_IF (NAT)"
echo ""
echo "[i] Tailnet -> LAN NOT enabled"
