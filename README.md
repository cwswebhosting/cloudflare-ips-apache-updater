# ☁️ Apache Cloudflare Real IP Restorer

Automated Real IP Restoration for Apache on AlmaLinux 9 & Virtualmin

# 📖 Introduction

A professional, lightweight bash tool designed for Linux System Administrators, Web Hosting Providers, and Virtualmin/Webmin users.

If you use Cloudflare as a proxy for your AlmaLinux 9 or RHEL server, Apache will by default log Cloudflare's proxy IPs instead of your visitors' real IP addresses. This tool fixes that issue by automating mod_remoteip configuration, ensuring your logs, security plugins (Fail2Ban), and PHP applications see the correct Real Visitor IP.

✨ Features

Core Capabilities

🔄 Automated IP Sync - Fetches the latest IPv4 and IPv6 ranges directly from Cloudflare's official API.

🎯 Precision Configuration - Generates a clean /etc/httpd/conf.d/cloudflare.conf without bloating your main config.

📝 Log Correction - automatically detects and updates the Apache LogFormat to use %a (Client IP) instead of %h (Proxy IP).

⚡ Zero-Downtime - Performs a graceful reload (systemctl reload httpd) to apply changes without dropping connections.

🕒 Auto-Pilot Mode - Includes an installer that sets up a weekly Cron Job for maintenance-free operation.

# 🚀 Quick Start

1. Installation

SSH into your server as root and clone the repository:

Clone the repository
```bash
git clone [https://github.com/cwswebhosting/cloudflare-ips-apache-updater.git](https://github.com/cwswebhosting/cloudflare-ips-apache-updater.git)
cd cloudflare-ips-apache-updater
```

 Make scripts executable
```bash
chmod +x *.sh
```

 2. One-Click Setup

Run the installer to set up the script and the automatic scheduler:
```bash
sudo ./install.sh
```

That's it! Your server is now configured to see real IPs.

 🛠 Manual Usage

If you prefer to run the update manually or debug the output:
```bash
sudo ./update_ip.sh
```

# ✅ Verification & Troubleshooting

Use these commands to verify the installation on your VPS or Dedicated Server.

1. Verify Module Status

Check if mod_remoteip is loaded in Apache.
```bash
httpd -M | grep remoteip
```
 Expected Output: remoteip_module (shared)


2. Verify Cloudflare Configuration

Ensure the configuration file exists and contains IPs.

```bash
cat /etc/httpd/conf.d/cloudflare.conf
```
 Should list many "RemoteIPTrustedProxy" lines


3. Check Apache Syntax

Always run this before restarting the service manually.

```bash
apachectl -t
```
 Expected Output: Syntax OK


4. Live Log Verification

Tail your access logs and visit your website. You should see your ISP/Home IP, not a Cloudflare IP.

 For standard Apache
 
 ```bash
tail -f /var/log/httpd/access_log
```
 For Virtualmin users

 ```bash
tail -f /var/log/virtualmin/yourdomain.com_access_log
```

5. Verify Automation

Check if the cron job is scheduled correctly.

```bash
crontab -l | grep update_cloudflare_ip
```

# 📋 Technical Implementation

Why mod_remoteip?

On RHEL 9 and AlmaLinux 9, mod_cloudflare is deprecated and no longer supported. The industry standard is mod_remoteip, which comes built-in with Apache 2.4.

This script configures mod_remoteip to:

Trust headers from Cloudflare IPs.

Read the CF-Connecting-IP header.

Rewrite the $REMOTE_ADDR variable in PHP and Apache.

Log Format Changes

The script safely modifies /etc/httpd/conf/httpd.conf to ensure logs are accurate:

From: LogFormat "%h %l %u %t ... (Logs Remote Host / Proxy)

To: LogFormat "%a %l %u %t ... (Logs Client IP Address)

# 🛡️ Security Note

This script fetches IPs from https://www.cloudflare.com/ips-v4 and ips-v6 over HTTPS to ensure the integrity of the trusted proxy list.

# 📄 License
MIT License - See LICENSE file for details.

Made for AlmaLinux & Virtualmin Administrators

Need VPS?: https://ciscowebservers.com/linux-vps-ssd-hosting-packages/

Need Dedicated servers?: https://ciscowebservers.com/linux-dedicated-servers-hosting-packages/
