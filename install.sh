#!/bin/bash
# File: cloudflare-ips-apache-updater/install.sh
# Description: Installs the updater script to /usr/local/bin and sets up a weekly cron job.
# Author: https://github.com/cwswebhosting

INSTALL_DIR="/usr/local/bin"
SCRIPT_SOURCE="update_ip.sh"
SCRIPT_TARGET="$INSTALL_DIR/update_cloudflare_ip.sh"

# Check for root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root"
  exit 1
fi

echo "🚀 Installing Cloudflare Apache Updater..."

# 1. Install Script
if [ -f "$SCRIPT_SOURCE" ]; then
    cp "$SCRIPT_SOURCE" "$SCRIPT_TARGET"
    chmod +x "$SCRIPT_TARGET"
    echo "✅ Script installed to $SCRIPT_TARGET"
else
    echo "❌ Error: $SCRIPT_SOURCE not found in current directory."
    exit 1
fi

# 2. Setup Cron Job (Weekly: Sunday at 03:00 AM)
CRON_CMD="$SCRIPT_TARGET > /dev/null 2>&1"
CRON_SCHEDULE="0 3 * * 0"

# Check if cron exists
if crontab -l 2>/dev/null | grep -q "$SCRIPT_TARGET"; then
    echo "ℹ️  Cron job already exists."
else
    (crontab -l 2>/dev/null; echo "$CRON_SCHEDULE $CRON_CMD") | crontab -
    echo "✅ Weekly cron job scheduled (Sunday @ 3am)."
fi

# 3. Run Initial Update
echo "🔄 Running initial update now..."
$SCRIPT_TARGET

echo ""
echo "==================================================="
echo "🎉 Installation Complete!"
echo "Your Apache server will now automatically sync"
echo "Cloudflare IPs every week."
echo "==================================================="
