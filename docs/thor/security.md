# Thor Security Configuration

Security hardening, access control, and threat mitigation for the thor homelab server.

## Security Overview

Thor implements defense-in-depth with multiple security layers:
1. **Network Security**: Firewall, VPN, isolated services
2. **Access Control**: SSH hardening, authentication, authorization
3. **Intrusion Prevention**: Fail2ban, monitoring, alerting
4. **Data Protection**: Encryption, backups, impermanence
5. **Secret Management**: Agenix (age-encrypted secrets)

## Network Security

### Firewall Configuration

**Default Policy**: DENY inbound, ALLOW outbound

**Allowed Ports** (Global):
| Port | Service | Source | Notes |
|------|---------|--------|-------|
| 22 | SSH | All | Key-only, Fail2ban protected |
| 80 | HTTP (Nginx) | All | Reverse proxy, no direct service exposure |
| 443 | HTTPS (Nginx) | All | Future SSL termination |

**Tailscale-Restricted Ports**:
| Port | Service | Source | Notes |
|------|---------|--------|-------|
| 445 | Samba | Tailscale | ⚠️ Guest access enabled |
| 2049 | NFS | Tailscale | Secure file sharing |
| 111 | Rpcbind (NFS) | Tailscale | NFS dependency |
| 20048 | NFS Status | Tailscale | NFS dependency |

**Service Isolation**:
- All web services bind to `127.0.0.1` (localhost only)
- Nginx reverse proxy provides single entry point
- No direct internet exposure of service ports

**Configuration References**:
- Base firewall: [`modules/nixos/services/network/nginx.nix`](../../modules/nixos/services/network/nginx.nix)
- NFS firewall: [`modules/nixos/services/network/nfs.nix`](../../modules/nixos/services/network/nfs.nix)

### Network Segmentation

**Network Zones**:
1. **Public Internet** → Cloudflared Tunnel → Nginx (80)
2. **Tailscale VPN** → Services (direct or via Nginx)
3. **Local LAN** → Services (via Nginx or direct where needed)
4. **Localhost** → Service-to-service communication

**Tailscale Configuration**:
- Mesh VPN with ACLs (Access Control Lists)
- Exit node for secure internet access
- Subnet routing: Advertises 192.168.68.0/24
- MagicDNS: Hostname resolution without external DNS

**Configuration**: [`roles/homelab.nix`](../../roles/homelab.nix) (services.tailscale)

### Cloudflared Tunnel Security

**Benefits**:
- No port forwarding on router (no exposed public IP)
- SSL termination at Cloudflare edge
- DDoS protection via Cloudflare
- WAF (Web Application Firewall) available
- Zero Trust access with Cloudflare Access (optional)

**Tunnel Configuration**:
- Tunnel ID: 23c4423f-ec30-423b-ba18-ba18904ddb85
- Credentials: Age-encrypted via agenix
- Ingress: `*.greensroad.uk` → `http://localhost:80`
- Default: HTTP 404 for unmatched routes

**Security Considerations**:
- All traffic is TLS encrypted (Cloudflare to client)
- Internal traffic is HTTP (Nginx to services)
- Consider enabling Cloudflare Access for sensitive services

**Configuration**: [`roles/homelab.nix`](../../roles/homelab.nix) (services.cloudflared)

## Access Control

### SSH Hardening

**Configuration** ([`modules/nixos/services/network/ssh.nix`](../../modules/nixos/services/network/ssh.nix)):
```nix
services.openssh = {
  enable = true;
  settings = {
    PasswordAuthentication = false;  # Key-only
    PermitRootLogin = "no";          # No root login
    MaxAuthTries = 3;                # Limit attempts
    LoginGraceTime = 300;            # 5min timeout
  };
};
```

**Best Practices**:
- ✅ Public key authentication only
- ✅ Root login disabled
- ✅ Fail2ban protection (3 failures → 24h ban)
- ✅ Tailscale SSH available (`--ssh` flag)

**Authorized Keys**: Managed via NixOS configuration or impermanence

### Sudo Configuration

**Configuration** ([`roles/common.nix` or system modules](../../roles/common.nix)):
```nix
security.sudo = {
  wheelNeedsPassword = true;  # Password required for sudo
};
```

**Policy**:
- ❌ No passwordless sudo
- ✅ User must be in `wheel` group
- ✅ Password required for all sudo operations
- ✅ TouchID authentication on macOS (not applicable to thor)

### Service Authentication

**Web Services**:
- Most services: No built-in authentication (protected by network segmentation)
- Recommendation: Use Authelia or Authentik for unified SSO
- Current: Rely on Cloudflare Access or Tailscale ACLs for access control

***arr Services**:
- Authentication: `DisabledForLocalAddresses` (from [`lib/constants.nix`](../../lib/constants.nix))
- Access: Behind nginx proxy, requires network access
- API Keys: Stored in agenix secrets

**Grafana**:
- Default admin credentials (change immediately!)
- Consider enabling OAuth or LDAP

**PostgreSQL**:
- Local connections: Peer authentication
- Network connections: Password authentication (Tailscale only)
- User-specific credentials in service configurations

## Intrusion Prevention

### Fail2ban Configuration

**Purpose**: Automatic IP banning based on failed authentication attempts

**Jails Enabled**:
1. **SSH**: 3 failed attempts → 24h ban
2. **Nginx HTTP Auth**: Failed HTTP authentication → ban
3. **Nginx Bad Requests**: Malicious request patterns → ban

**Progressive Ban Times**:
- First offense: 24 hours
- Second offense: 48 hours (exponential backoff)
- Subsequent: Progressively longer (up to 7 days)

**Configuration**: [`modules/nixos/services/security/fail2ban.nix`](../../modules/nixos/services/security/fail2ban.nix)

**Monitoring**:
```bash
# Check banned IPs
sudo fail2ban-client status sshd

# Unban IP
sudo fail2ban-client unban <IP>

# View fail2ban logs
journalctl -u fail2ban -f
```

### Security Monitoring

**Log Collection** (Loki + Promtail):
- All systemd service logs
- Nginx access and error logs
- SSH authentication attempts
- Fail2ban ban events

**Useful Log Queries**:
```logql
# Failed SSH attempts
{job="systemd-journal", unit="sshd.service"} |= "Failed password"

# Fail2ban bans
{job="systemd-journal", unit="fail2ban.service"} |= "Ban"

# Nginx 4xx/5xx errors
{job="nginx-access"} | regexp `HTTP/[0-9.]+ [45][0-9]{2}`

# Sudo usage
{job="systemd-journal"} |= "sudo"
```

**Alerting**:
- Abnormal login patterns
- Repeated failed authentication
- Service access from unusual IPs
- Configuration changes (Git commits)

## Data Protection

### Encryption

**At Rest**:
- ❌ ZFS native encryption not enabled (consider for sensitive data)
- ✅ Restic backups are encrypted (AES-256)
- ✅ Secrets encrypted with age (agenix)

**In Transit**:
- ✅ Cloudflared tunnel: TLS encrypted
- ✅ Tailscale: WireGuard encrypted
- ⚠️ Internal services: HTTP (unencrypted, localhost only)
- ⚠️ NFS/Samba: Unencrypted (Tailscale network only)

**Recommendations**:
1. Enable ZFS native encryption for new datasets with sensitive data
2. Consider enabling HTTPS for internal nginx (self-signed certs OK)
3. Use SMB3 encryption for Samba (if clients support)

### Secret Management (Agenix)

**Purpose**: Secure storage of sensitive configuration data

**Secrets Stored**:
- Cloudflared tunnel credentials
- *arr service API keys
- Database passwords
- SMTP credentials (if used)

**Secret Locations**:
- Encrypted files: `secrets/*.age`
- Decrypted at boot: `/run/agenix/<secret-name>`
- Readable only by specified users/services

**Adding Secrets**:
```bash
# Edit secret (requires agenix CLI on Linux)
agenix -e secrets/new-secret.age

# Rekey all secrets (after adding new host key)
agenix -r
```

**Best Practices**:
- ✅ Secrets never committed in plaintext
- ✅ Age keys managed securely
- ✅ Rotate secrets periodically
- ❌ Don't store secrets in Nix configuration

**Configuration**: `secrets/*.nix` and `secrets/*.age`

### Impermanence Security Benefits

**Stateless Root Filesystem**:
- Root (`/`) reset on every boot
- Malware persistence difficult
- Clean slate prevents configuration drift
- Leaked credentials cleared on reboot

**Persistent Locations** (secure these):
- `/persist`: System state (SSH keys, machine ID)
- `/srv`: Service data (databases, configs)
- `/nix`: Nix store (reproducible, integrity-checked)

**Security Implications**:
- ✅ Reduces attack surface
- ✅ Forces declarative configuration
- ✅ Easy rollback to known-good state
- ⚠️ Persistent locations must be secured

## Security Best Practices

### System Hardening

**Completed**:
- ✅ SSH key-only authentication
- ✅ Root login disabled
- ✅ Fail2ban enabled
- ✅ Sudo password required
- ✅ Impermanence for stateless root
- ✅ Firewall with default deny
- ✅ Service isolation (localhost binding)

**Recommended**:
- [ ] Enable ZFS encryption for sensitive datasets
- [ ] Implement centralized authentication (Authelia/Authentik)
- [ ] Enable 2FA for critical services (Grafana, Jellyfin admin)
- [ ] Configure SELinux or AppArmor profiles
- [ ] Enable audit logging (auditd)
- [ ] Implement certificate-based authentication for Nginx

### Network Hardening

**Completed**:
- ✅ Tailscale VPN for remote access
- ✅ Cloudflared tunnel for external access
- ✅ NFS/Samba restricted to Tailscale
- ✅ Service port binding to localhost

**Recommended**:
- [ ] Enable Cloudflare Access (Zero Trust)
- [ ] Implement VLANs for network segmentation
- [ ] Use Nginx with HTTPS internally
- [ ] Enable Tailscale ACLs for service-level access control
- [ ] Audit firewall rules quarterly

### Service Hardening

**Completed**:
- ✅ Services run as dedicated users (systemd DynamicUser)
- ✅ Minimal permissions (systemd security directives)
- ✅ Secret management via agenix
- ✅ Service logs collected and monitored

**Recommended**:
- [ ] Enable authentication on all web services
- [ ] Implement rate limiting (nginx)
- [ ] Use read-only root filesystem for containers
- [ ] Enable service-specific security modules
- [ ] Audit service configurations regularly

## Security Incidents

### Incident Response Plan

**Phase 1: Detection**
1. Monitor alerts (Alertmanager, Uptime Kuma)
2. Review logs (Loki) for anomalies
3. Check Fail2ban for ban events
4. Review Grafana dashboards

**Phase 2: Containment**
1. Isolate affected service: `sudo systemctl stop <service>`
2. Block malicious IPs: `sudo fail2ban-client ban <IP>`
3. Disconnect from network (if severe): `sudo ip link set eno1 down`
4. Snapshot current state: `sudo zfs snapshot zroot/local/srv@incident-$(date +%Y%m%d)`

**Phase 3: Investigation**
1. Collect logs: `journalctl -u <service> > /tmp/incident-logs.txt`
2. Review recent changes: `git log -n 10`
3. Check file integrity: `ls -la /srv/<service>`
4. Analyze network connections: `sudo ss -tulpn`

**Phase 4: Eradication**
1. Remove malware/backdoors
2. Rotate compromised credentials
3. Apply patches/updates
4. Rebuild from known-good configuration

**Phase 5: Recovery**
1. Restore from backup (if needed)
2. Verify system integrity
3. Restart services
4. Monitor for recurrence

**Phase 6: Post-Incident**
1. Document incident (date, time, impact, root cause)
2. Update security controls
3. Implement additional monitoring
4. Share lessons learned

### Common Security Scenarios

**Scenario: Unauthorized SSH Access Attempts**
```bash
# Check failed login attempts
journalctl -u sshd | grep "Failed password"

# Review Fail2ban bans
sudo fail2ban-client status sshd

# If excessive, consider changing SSH port or restricting by IP
```

**Scenario: Compromised Service Account**
```bash
# Rotate API key in agenix
agenix -e secrets/service-api.age

# Rebuild to apply new secret
sudo nixos-rebuild switch --flake .#thor

# Review service logs for unauthorized actions
journalctl -u <service> --since "24 hours ago" | grep -i "auth\|error"
```

**Scenario: Malware Detection**
```bash
# Stop affected service
sudo systemctl stop <service>

# Snapshot current state for forensics
sudo zfs snapshot zroot/local/srv@malware-$(date +%Y%m%d)

# Reboot (impermanence clears root filesystem)
sudo systemctl reboot

# Restore service data from clean backup
# See Backup & Recovery documentation
```

## Security Audit Checklist

### Monthly
- [ ] Review Fail2ban ban logs
- [ ] Check for failed SSH attempts
- [ ] Audit sudo usage logs
- [ ] Review Nginx access logs for anomalies
- [ ] Verify all services are up-to-date
- [ ] Check for exposed ports: `sudo ss -tulpn`

### Quarterly
- [ ] Update all packages: `nix flake update && sudo nixos-rebuild switch`
- [ ] Rotate API keys and passwords
- [ ] Review firewall rules
- [ ] Audit user accounts and permissions
- [ ] Test backup restore procedure
- [ ] Review Tailscale ACLs
- [ ] Scan for vulnerabilities (nmap, lynis)

### Annually
- [ ] Full security audit
- [ ] Penetration testing (if applicable)
- [ ] Review and update security policies
- [ ] Disaster recovery drill
- [ ] Rotate SSH keys
- [ ] Review age keys for agenix

## Security Tools

### Vulnerability Scanning
```bash
# Nmap port scan (from external host)
nmap -sV thor

# Lynis security audit (on thor)
nix-shell -p lynis --run "sudo lynis audit system"
```

### Log Analysis
```bash
# Find suspicious patterns in logs
journalctl --since "24 hours ago" | grep -iE "hack|exploit|malware|backdoor"

# Check for unusual network connections
sudo ss -tulpn | grep -v "127.0.0.1\|::1"

# Review recent sudo usage
journalctl | grep sudo
```

### File Integrity
```bash
# Check for unexpected files in /srv
find /srv -type f -mtime -1  # Modified in last 24h

# Verify Nix store integrity
nix-store --verify --check-contents
```

## Security Contacts

**Reporting Security Issues**:
- Internal: Review with system administrator
- External: Create private GitHub issue

**Security Resources**:
- NixOS Security Advisories: https://nixos.org/security.html
- Tailscale Security: https://tailscale.com/security
- Cloudflare Security: https://www.cloudflare.com/trust-hub

## Related Documentation
- [🌐 Network Configuration](network-configuration.md) - Firewall and network security
- [🔧 Services Inventory](services/README.md) - Service-specific security notes
- [💾 Backup & Recovery](backup-and-recovery.md) - Data protection
- [🔍 Troubleshooting Guide](troubleshooting-guide.md) - Security incident response
- [🔙 Back to Thor Overview](README.md)

---

**Security Notice**: This is a homelab environment. Adjust security measures based on your risk tolerance and data sensitivity. For production environments, implement stricter controls and regular audits.

**Configuration Sources**:
- SSH: [`modules/nixos/services/network/ssh.nix`](../../modules/nixos/services/network/ssh.nix)
- Fail2ban: [`modules/nixos/services/security/fail2ban.nix`](../../modules/nixos/services/security/fail2ban.nix)
- Firewall: Various service modules
- Secrets: `secrets/*.age`
