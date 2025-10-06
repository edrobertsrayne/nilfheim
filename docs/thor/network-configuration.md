# Thor Network Configuration

Comprehensive network configuration for the thor homelab server, including LAN, VPN, DNS, firewall, and reverse proxy setup.

## Table of Contents
- [Network Interfaces](#network-interfaces)
- [IP Addressing](#ip-addressing)
- [DNS Configuration](#dns-configuration)
- [Firewall Rules](#firewall-rules)
- [Reverse Proxy](#reverse-proxy)
- [VPN & Remote Access](#vpn--remote-access)
- [Network Services](#network-services)

## Network Interfaces

| Interface | Type | Purpose | Configuration |
|-----------|------|---------|---------------|
| `eno1` | Ethernet | Primary LAN connection | DHCP (static assignment via router) |
| `tailscale0` | Virtual | Tailscale mesh VPN | Dynamic (Tailscale-managed) |

**Configuration Reference**: [`hosts/thor/hardware-configuration.nix`](../../hosts/thor/hardware-configuration.nix)

## IP Addressing

### Local Area Network (LAN)
- **IP Address**: 192.168.68.122
- **Assignment Method**: DHCP with static reservation (router-side)
- **Subnet**: 192.168.68.0/24
- **Gateway**: 192.168.68.1 (assumed)
- **Interface**: eno1

### Tailscale VPN
- **Tailscale IP**: Assigned by Tailscale (100.64.0.0/10 CGNAT range)
- **IPv6**: fd7a:115c:a1e0::/48 (Tailscale range)
- **Interface**: tailscale0
- **MagicDNS**: Enabled (hostname: `thor`)

### Cloudflared Tunnel
- **Tunnel ID**: 23c4423f-ec30-423b-ba18-ba18904ddb85
- **Domain**: greensroad.uk
- **Ingress**: `*.greensroad.uk` → `http://localhost:80` (nginx)
- **Fallback**: HTTP 404 for unmatched routes

**Configuration Reference**: [`roles/homelab.nix`](../../roles/homelab.nix) (lines 45-53)

## DNS Configuration

### Blocky DNS Proxy
- **Port**: 4000
- **Purpose**: Local DNS resolver with ad-blocking
- **Backend**: PostgreSQL logging (port 5432)
- **Upstream**: Configured DNS providers (Cloudflare, Google, etc.)
- **Access**: Local network only

**Service Configuration**: [`modules/nixos/services/network/blocky.nix`](../../modules/nixos/services/network/blocky.nix)

### DNS Resolution Flow
```
Client → Blocky (4000) → Upstream DNS
                     ↓
                PostgreSQL (logging)
                     ↓
             Grafana Dashboard (analytics)
```

### Avahi/mDNS
- **Port**: 5353
- **Purpose**: Local network discovery
- **Services Advertised**: SMB, NFS, HTTP
- **Firewall**: Allowed on LAN interface

**Configuration**: [`modules/nixos/services/network/avahi.nix`](../../modules/nixos/services/network/avahi.nix)

## Firewall Rules

### Default Policy
- **Inbound**: DENY (except explicitly allowed)
- **Outbound**: ALLOW
- **Stateful**: Yes (connection tracking enabled)

### Allowed TCP Ports (Global)
| Port | Service | Notes |
|------|---------|-------|
| 22 | SSH | Key-based authentication only |
| 80 | HTTP (Nginx) | Redirects to HTTPS or serves proxied services |
| 443 | HTTPS (Nginx) | SSL termination (future, currently HTTP only) |
| 445 | Samba/SMB | File sharing (restricted to tailscale network) |

**Reference**: [`modules/nixos/services/network/nginx.nix`](../../modules/nixos/services/network/nginx.nix) (lines 32)

### Tailscale-Specific Rules
- **NFS Ports** (2049, 111, 20048): Allowed on `tailscale0` interface
- **Samba** (445): Allowed on `tailscale0` interface
- **Subnet Routing**: Advertises 192.168.68.0/24 to Tailscale peers

**Configuration**: [`modules/nixos/services/network/nfs.nix`](../../modules/nixos/services/network/nfs.nix)

### Service-Specific Firewall Openings
Services automatically open required ports via their NixOS modules:
- Nginx: 80, 443
- Avahi: 5353 (UDP)
- Tailscale: 41641 (UDP)

### Intrusion Prevention (Fail2ban)
- **Enabled**: Yes
- **Jails**: SSH, Nginx HTTP Auth
- **Ban Duration**: 24 hours (progressive)
- **Max Retries**: 3 attempts

**Configuration**: [`modules/nixos/services/security/fail2ban.nix`](../../modules/nixos/services/security/fail2ban.nix)

## Reverse Proxy (Nginx)

### Architecture
```
Internet/Tailscale → Cloudflared Tunnel → Nginx (80) → Backend Services (localhost ports)
```

### Nginx Configuration
- **Enabled**: Yes
- **Ports**: 80 (HTTP)
- **Recommended Settings**: gzip, optimization, TLS, proxy headers
- **Default Virtual Host**: Returns 444 (connection closed)

**Base Configuration**: [`modules/nixos/services/network/nginx.nix`](../../modules/nixos/services/network/nginx.nix)

### Virtual Host Pattern
All services follow this pattern:
```nix
services.nginx.virtualHosts."<service>.greensroad.uk" = {
  locations."/" = {
    proxyPass = "http://127.0.0.1:<port>";
    proxyWebsockets = true;
  };
};
```

### WebSocket Support
- **Upgrade Mapping**: Configured globally in Nginx `appendHttpConfig`
- **Enabled by Default**: Via `proxyWebsockets = true` on all service proxies
- **Use Case**: Real-time services (Homepage, Grafana, N8N, etc.)

### Service Proxy Table
| Service | Domain | Backend Port |
|---------|--------|--------------|
| Jellyfin | jellyfin.greensroad.uk | 8096 |
| Sonarr | sonarr.greensroad.uk | 8989 |
| Radarr | radarr.greensroad.uk | 7878 |
| Prowlarr | prowlarr.greensroad.uk | 9696 |
| Prometheus | prometheus.greensroad.uk | 9090 |
| Grafana | grafana.greensroad.uk | 3000 |
| Homepage | homepage.greensroad.uk | 3002 |
| Uptime Kuma | uptime-kuma.greensroad.uk | 3001 |
| ... | ... | ... (see service docs) |

*Full list: [`lib/constants.nix`](../../lib/constants.nix) ports definition*

### SSL/TLS
- **Current**: HTTP only (SSL termination at Cloudflared)
- **Cloudflared**: Provides HTTPS externally
- **Internal**: HTTP between Nginx and services (localhost)

## VPN & Remote Access

### Tailscale Mesh VPN
**Configuration** ([`roles/homelab.nix`](../../roles/homelab.nix)):
```nix
services.tailscale = {
  useRoutingFeatures = "server";
  extraUpFlags = [
    "--exit-node 10.71.91.83"
    "--exit-node-allow-lan-access=true"
    "--advertise-routes \"192.168.68.0/24\""
  ];
  extraSetFlags = [
    "--exit-node-allow-lan-access=true"
  ];
};
```

**Features**:
- **Exit Node**: Uses 10.71.91.83 as internet gateway
- **LAN Access**: Allows exit node to access LAN
- **Subnet Routing**: Advertises 192.168.68.0/24 to Tailscale network
- **MagicDNS**: Accessible as `thor` from other Tailscale devices
- **SSH over Tailscale**: Enabled via `--ssh` flag (from server role)

**Use Cases**:
- Remote access to thor from any Tailscale device
- Access to LAN devices (192.168.68.0/24) from Tailscale peers
- Secure NFS/Samba access without exposing to public internet

### Cloudflared Tunnel
**Purpose**: Secure external access to web services without exposing server IP

**Tunnel Configuration**:
- **Tunnel ID**: 23c4423f-ec30-423b-ba18-ba18904ddb85
- **Credentials**: Encrypted via agenix (`config.age.secrets.cloudflare-homelab.path`)
- **Ingress Rules**:
  - `*.greensroad.uk` → `http://localhost:80` (nginx)
  - Default → HTTP 404

**How It Works**:
1. External client connects to `https://<service>.greensroad.uk`
2. Cloudflare edge terminates SSL
3. Cloudflared tunnel (running on thor) forwards request to nginx (port 80)
4. Nginx proxies to appropriate backend service

**Security Benefits**:
- No port forwarding required on router
- SSL termination at Cloudflare edge
- DDoS protection via Cloudflare
- Hide server's public IP address

**Configuration Reference**: [`roles/homelab.nix`](../../roles/homelab.nix) (services.cloudflared)

## Network Services

### NFS Server
**Purpose**: Network file sharing to Tailscale clients (primarily freya)

**Exports** (from [`hosts/thor/default.nix`](../../hosts/thor/default.nix)):
| Share | Source | Permissions | Clients |
|-------|--------|-------------|---------|
| downloads | /mnt/downloads | RW | Tailscale network |
| media | /mnt/media | RO | Tailscale network |
| backup | /mnt/backup | RW | Tailscale network |
| share | /mnt/share | RW | Tailscale network |

**Network Restriction**: Only accessible via Tailscale (100.64.0.0/10)

**Firewall Rules**:
- 2049/TCP (NFS)
- 111/TCP (rpcbind)
- 20048/TCP (nfs-status)

**Configuration**: [`modules/nixos/services/network/nfs.nix`](../../modules/nixos/services/network/nfs.nix)

### Samba/SMB Server
**Purpose**: SMB file sharing for Windows/macOS clients

**Shares** (from [`hosts/thor/default.nix`](../../hosts/thor/default.nix)):
| Share | Path | Read Only | Guest Access | Force User/Group |
|-------|------|-----------|--------------|------------------|
| downloads | /mnt/downloads | No | Yes | ed:tank |
| media | /mnt/media | Yes | Yes | ed:tank |
| backup | /mnt/backup | No | Yes | ed:tank |
| share | /mnt/share | No | Yes | ed:tank |

**Permissions**:
- **Create Mask**: 0644 (files)
- **Directory Mask**: 0755 (directories)
- **Force User**: ed
- **Force Group**: tank

**Security Note**: ⚠️ Guest access enabled - consider restricting to Tailscale network only

**Port**: 445/TCP

**Configuration**: [`modules/nixos/services/utilities/samba.nix`](../../modules/nixos/services/utilities/samba.nix)

### SSH Server
**Purpose**: Secure remote access and administration

**Configuration**:
- **Port**: 22
- **Authentication**: Public key only (PasswordAuthentication = no)
- **Root Login**: Disabled (PermitRootLogin = no)
- **Max Auth Tries**: 3
- **Timeout**: 5 minutes idle

**Intrusion Prevention**: Fail2ban monitors SSH attempts (3 failures → 24h ban)

**Tailscale SSH**: Enabled via `--ssh` flag (uses Tailscale's SSH ACLs)

**Configuration**: [`modules/nixos/services/network/ssh.nix`](../../modules/nixos/services/network/ssh.nix)

## Network Topology

```
┌─────────────────────────────────────────────────────────────────┐
│                     Internet / Remote Clients                    │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                    ┌───────┴────────┐
                    │ Cloudflare Edge │
                    │  (SSL/DDoS)     │
                    └───────┬────────┘
                            │ Cloudflared Tunnel
                            │ (ID: 23c4423f...)
                            ▼
         ┌──────────────────────────────────────────────┐
         │              Thor (192.168.68.122)           │
         │  ┌────────────────────────────────────────┐  │
         │  │  Nginx Reverse Proxy (Port 80)        │  │
         │  └─────┬──────────────────────────────────┘  │
         │        │                                      │
         │  ┌─────┴──────────────────────────────────┐  │
         │  │  Backend Services (localhost ports)    │  │
         │  │  - Jellyfin (8096)                     │  │
         │  │  - Grafana (3000)                      │  │
         │  │  - Sonarr (8989)                       │  │
         │  │  - Prometheus (9090)                   │  │
         │  │  - ... (40+ services)                  │  │
         │  └────────────────────────────────────────┘  │
         │                                               │
         │  ┌────────────────────────────────────────┐  │
         │  │  Network Services                      │  │
         │  │  - Blocky DNS (4000)                   │  │
         │  │  - NFS Server (2049) - Tailscale only  │  │
         │  │  - Samba (445) - Tailscale/LAN         │  │
         │  │  - SSH (22)                            │  │
         │  └────────────────────────────────────────┘  │
         └───┬─────────────────────────────────┬────────┘
             │                                 │
      ┌──────┴──────┐                   ┌─────┴──────┐
      │ Tailscale   │                   │ Local LAN  │
      │ VPN Mesh    │                   │ 192.168.68 │
      │ (100.64/10) │                   │ .0/24      │
      └─────────────┘                   └────────────┘
           │                                  │
    ┌──────┴─────────┐              ┌────────┴────────┐
    │ Remote Clients │              │ Local Clients   │
    │ - Freya (NFS)  │              │ - Smart TVs     │
    │ - Laptops      │              │ - Phones        │
    │ - Phones       │              │ - PCs           │
    └────────────────┘              └─────────────────┘
```

## Troubleshooting Network Issues

### Check Network Interfaces
```bash
# List interfaces and IPs
ip addr show

# Check interface status
ip link show eno1
ip link show tailscale0

# Test connectivity
ping 192.168.68.1  # Gateway
ping 8.8.8.8       # Internet
```

### Check Firewall
```bash
# List firewall rules
sudo iptables -L -v -n

# Check open ports
sudo ss -tulpn | grep LISTEN
```

### Test DNS
```bash
# Query Blocky
dig @127.0.0.1 -p 4000 example.com

# Check Blocky status
systemctl status blocky

# View Blocky logs
journalctl -u blocky -f
```

### Check Reverse Proxy
```bash
# Test Nginx configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx

# Check Nginx status
systemctl status nginx

# View Nginx access logs
journalctl -u nginx -f
```

### Test Tailscale
```bash
# Check Tailscale status
tailscale status

# Test connectivity to peer
ping freya  # MagicDNS

# Check routes
tailscale status --json | jq '.Self.AllowedIPs'
```

### Test Cloudflared Tunnel
```bash
# Check tunnel status
systemctl status cloudflared-tunnel-23c4423f-ec30-423b-ba18-ba18904ddb85

# View tunnel logs
journalctl -u cloudflared-tunnel-23c4423f-ec30-423b-ba18-ba18904ddb85 -f

# Test external access
curl -I https://homepage.greensroad.uk
```

## Security Considerations

### Exposed Services
- ✅ **SSH (22)**: Secured (key-only, Fail2ban)
- ✅ **HTTP/HTTPS (80/443)**: Behind Cloudflared tunnel
- ⚠️ **Samba (445)**: Guest access enabled
- ✅ **NFS (2049)**: Tailscale-only

### Recommendations
1. **Restrict Samba**: Consider disabling guest access or limiting to Tailscale
2. **Enable HTTPS**: Add SSL certificates for local access
3. **Monitor Fail2ban**: Review ban logs regularly
4. **Audit Firewall**: Periodically review open ports
5. **Update Services**: Keep all services patched

## Related Documentation
- [🔒 Security Configuration](security.md)
- [🔧 Services Inventory](services/README.md)
- [🏗️ System Architecture](system-architecture.md)
- [🔙 Back to Thor Overview](README.md)

---

**Configuration Sources**:
- [`roles/homelab.nix`](../../roles/homelab.nix)
- [`modules/nixos/services/network/`](../../modules/nixos/services/network/)
- [`lib/constants.nix`](../../lib/constants.nix)
