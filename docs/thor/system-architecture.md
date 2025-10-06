# Thor System Architecture

Thor is the central homelab server running NixOS with ZFS storage, providing media services, automation, and monitoring for the Nilfheim infrastructure.

## Table of Contents
- [Hardware Specifications](#hardware-specifications)
- [Boot Configuration](#boot-configuration)
- [Storage Architecture](#storage-architecture)
- [System Software](#system-software)
- [Impermanence Setup](#impermanence-setup)
- [Performance Characteristics](#performance-characteristics)

## Hardware Specifications

### CPU & Memory
- **Platform**: x86_64-linux
- **Processor**: Intel (supports KVM virtualization)
- **CPU Features**: `kvm-intel` kernel module enabled
- **Microcode**: Intel microcode updates enabled via `hardware.cpu.intel.updateMicrocode`

### Storage Devices

| Device | Type | Purpose | ZFS Pool |
|--------|------|---------|----------|
| `/dev/nvme0n1` | NVMe SSD | System, services | `zroot` |
| `/dev/sda` | HDD | Media, downloads, backups | `tank` |

### Network Interfaces
- **eno1**: Primary Ethernet interface (DHCP enabled)
- **tailscale0**: Tailscale VPN interface (DHCP enabled)

### Kernel Modules
- **Available**: `xhci_pci`, `ahci`, `nvme`, `usb_storage`, `usbhid`, `sd_mod`
- **Loaded**: `kvm-intel` (hardware virtualization)

**Configuration Reference**: [`hosts/thor/hardware-configuration.nix`](../../hosts/thor/hardware-configuration.nix)

## Boot Configuration

### Boot Loader
- **Type**: GRUB (EFI)
- **ESP Location**: `/boot` (500MB FAT32, `/dev/nvme0n1p2`)
- **BIOS Boot**: 1MB partition (`/dev/nvme0n1p1`, type EF02)

### Filesystem Support
- **Supported Filesystems**: ZFS
- **ZFS Pools**: `zroot` (auto-imported), `tank` (manually configured in `extraPools`)

### Boot Process
1. GRUB loads from ESP (/boot)
2. ZFS modules loaded
3. `zroot` pool imported automatically
4. `tank` pool imported from `boot.zfs.extraPools`
5. Impermanence applied (root filesystem rolled back to blank snapshot)
6. Systemd starts services

**Configuration Reference**: [`hosts/thor/disko-configuration.nix`](../../hosts/thor/disko-configuration.nix)

## Storage Architecture

### Disk Partitioning (Disko)

#### NVMe (`/dev/nvme0n1`) - System Disk
```
┌─────────────────────────────────────┐
│ /dev/nvme0n1p1 (1MB) - BIOS boot   │
├─────────────────────────────────────┤
│ /dev/nvme0n1p2 (500MB) - ESP/boot  │
├─────────────────────────────────────┤
│ /dev/nvme0n1p3 (rest) - zroot pool │
└─────────────────────────────────────┘
```

#### HDD (`/dev/sda`) - Storage Disk
```
┌─────────────────────────────────────┐
│ /dev/sda1 (100%) - tank pool       │
└─────────────────────────────────────┘
```

### ZFS Pool: zroot (System)

**Pool Configuration**:
- **Compression**: lz4 (optimized for speed with OS workloads)
- **Atime**: off (performance optimization)
- **ACL Type**: posixacl
- **Extended Attributes**: sa (system attribute based)
- **Ashift**: 12 (4K sectors)

**Dataset Layout**:
```
zroot
└── local
    ├── root (/)              - Ephemeral, reset on boot
    ├── nix (/nix)            - Persistent, Nix store
    ├── persist (/persist)    - Persistent, system state
    └── srv (/srv)            - Persistent, service data
```

| Dataset | Mountpoint | Snapshot | Purpose |
|---------|------------|----------|---------|
| `zroot/local/root` | `/` | ❌ No | Root filesystem (ephemeral) |
| `zroot/local/nix` | `/nix` | ❌ No | Nix store (large, reproducible) |
| `zroot/local/persist` | `/persist` | ❌ No | System persistence (SSH keys, etc.) |
| `zroot/local/srv` | `/srv` | ✅ Yes | Service data directories |

**Blank Snapshot**: `zroot/local/root@blank` - Created on first boot, root rolled back to this snapshot on each boot

### ZFS Pool: tank (Storage)

**Pool Configuration**:
- **Compression**: zstd (optimized for compression ratio with media/backup)
- **Atime**: off (performance optimization)
- **ACL Type**: posixacl
- **Extended Attributes**: sa
- **Ashift**: 12 (4K sectors)

**Dataset Layout**:
```
tank
├── backup (/mnt/backup)      - Backup storage
├── share (/mnt/share)        - General file share
├── media (/mnt/media)        - Media library
└── downloads (/mnt/downloads) - Download staging
```

| Dataset | Mountpoint | Snapshot | Mount Options | Purpose |
|---------|------------|----------|---------------|---------|
| `tank/backup` | `/mnt/backup` | ❌ No | nofail | Restic repository |
| `tank/share` | `/mnt/share` | ❌ No | nofail | General file sharing |
| `tank/media` | `/mnt/media` | ❌ No | nofail | Media library |
| `tank/downloads` | `/mnt/downloads` | ❌ No | nofail | Download staging |

**Mount Options**: `nofail` - System boots even if tank datasets fail to mount

### ZFS Snapshot Configuration

**Only `/srv` is auto-snapshotted** via `com.sun:auto-snapshot=true`

**Snapshot Schedule** (from `lib/constants.nix`):
| Type | Interval | Keep | Total Retention |
|------|----------|------|-----------------|
| Frequent | 15 minutes | 4 | 1 hour |
| Hourly | 1 hour | 24 | 24 hours |
| Daily | 1 day | 14 | 2 weeks |
| Weekly | 1 week | 8 | 2 months |
| Monthly | 1 month | 6 | 6 months |

**Snapshot Naming**: `zroot/local/srv@auto-{type}-{timestamp}`

**Rationale**: Media and downloads are not snapshotted (large, replaceable). System persistence and service data are snapshotted for quick recovery.

### Directory Permissions & Groups

**tank Group**: GID assigned dynamically, user `ed` added
- **Purpose**: Access control for tank datasets
- **Permissions**: `2775` (setgid, group-writable)
- **Owner**: `root:tank`

**Share Directories** (via systemd tmpfiles):
- `/mnt/downloads` - 2775 root:tank
- `/mnt/media` - 2775 root:tank
- `/mnt/backup` - 2775 root:tank
- `/mnt/share` - 2775 root:tank

## System Software

### NixOS Configuration
- **State Version**: Determined by role/common configuration
- **Flake-based**: Yes (inputs: nixpkgs, home-manager, disko, impermanence, etc.)
- **Configuration Style**: Modular (roles + modules + host-specific)

### Key Inputs
- **nixpkgs**: nixos-unstable channel
- **disko**: Declarative disk partitioning
- **impermanence**: Stateless root filesystem
- **home-manager**: User environment management
- **agenix**: Age-encrypted secrets
- **catppuccin**: Consistent theming

### System Roles
1. **homelab.nix**: Primary role, enables all homelab services
2. **server.nix**: Base server configuration (inherited by homelab)
3. **common.nix**: Universal settings (inherited by server)

**Configuration References**:
- [`hosts/thor/default.nix`](../../hosts/thor/default.nix)
- [`roles/homelab.nix`](../../roles/homelab.nix)
- [`roles/server.nix`](../../roles/server.nix)

## Impermanence Setup

Thor uses impermanence for security and reproducibility - the root filesystem is wiped on every boot.

### Ephemeral Filesystems
- **Root (`/`)**: Rolled back to blank snapshot on boot
- **Effect**: All state in `/` is lost unless explicitly persisted

### Persistent Locations
| Path | Purpose | Mounted From |
|------|---------|--------------|
| `/nix` | Nix store | `zroot/local/nix` |
| `/persist` | System state | `zroot/local/persist` |
| `/srv` | Service data | `zroot/local/srv` |
| `/mnt/backup` | Backup storage | `tank/backup` |
| `/mnt/media` | Media library | `tank/media` |
| `/mnt/downloads` | Downloads | `tank/downloads` |
| `/mnt/share` | File share | `tank/share` |

### What Persists
- **SSH Host Keys**: `/persist/etc/ssh/ssh_host_*`
- **Machine ID**: `/persist/etc/machine-id`
- **Service Data**: `/srv/<service>` (Prometheus, Grafana, Loki, etc.)
- **User Home**: Managed via impermanence module
- **NetworkManager**: `/persist/etc/NetworkManager/system-connections`
- **Systemd Logs**: `/var/log/journal` (optional persistence)
- **Private State**: `/var/lib/private` (mode 0700, for sensitive service data)

### Benefits
- **Clean Slate**: Every boot starts with a known-good state
- **Reproducibility**: Configuration is the source of truth
- **Security**: Leaked credentials or malware cleared on reboot
- **Debugging**: Easy to test changes (reboot to undo)

### Implications
- **New Services**: Must add persistence rules for service data
- **Manual Changes**: Lost on reboot (must be added to configuration)
- **Log Rotation**: Important for disk space (if logs persist)

**Configuration Reference**: `system.persist.*` options in NixOS modules

## Performance Characteristics

### Storage Performance

**NVMe (zroot)**:
- **Latency**: Low (sub-millisecond)
- **IOPS**: High (suitable for databases, small file operations)
- **Use Case**: OS, Nix store, service databases

**HDD (tank)**:
- **Latency**: Higher (~5-10ms)
- **Throughput**: Good for sequential reads/writes
- **Use Case**: Media files (large sequential access), backups

### ZFS Performance Tuning

**Compression**:
- `zroot`: lz4 (fast, low CPU overhead)
- `tank`: zstd (better compression, slightly higher CPU)

**Atime Disabled**: Improves performance by not updating access times

**ARC (Adaptive Replacement Cache)**:
- ZFS uses available RAM for read cache
- Significantly improves repeated read performance

### Service Performance

**Database Services**:
- PostgreSQL on NVMe (`/srv/postgresql`) - low latency
- Blocky DNS logs to PostgreSQL - high write throughput

**Media Transcoding**:
- Jellyfin and Tdarr use CPU for transcoding
- Consider GPU passthrough for hardware acceleration (future enhancement)

**Monitoring Overhead**:
- Prometheus exporters: minimal CPU/memory impact
- Promtail log shipping: moderate disk I/O
- Grafana dashboards: on-demand rendering

### Resource Allocation

**Memory**:
- ZFS ARC: Uses available memory dynamically
- Services: Each has systemd resource limits (if configured)
- Containers: Podman with resource constraints

**CPU**:
- Most services: Low baseline, spikes during activity
- Transcoding: High CPU during active streams
- Backups: Moderate CPU during Restic operations

**Disk I/O**:
- Writes: Journaled through ZFS, COW overhead
- Reads: Cached by ZFS ARC
- Snapshots: Nearly zero space cost (COW)

## Monitoring Architecture

Thor is fully instrumented with Prometheus exporters:
- **Node Exporter**: System metrics (CPU, memory, disk, network)
- **SMART Exporter**: Disk health (/dev/nvme0, /dev/sda)
- **ZFS Exporter**: Pool and dataset metrics
- **Exportarr**: *arr service statistics
- **Service-specific**: Many services expose /metrics endpoints

**Monitoring Access**: https://grafana.greensroad.uk

## Maintenance Notes

### Regular Maintenance
- **ZFS Scrub**: Schedule periodic scrubs (`zpool scrub zroot tank`)
- **SMART Monitoring**: Check disk health via smartctl-exporter
- **Snapshot Pruning**: Automatic via zfs-auto-snapshot service
- **Log Rotation**: Monitor `/var/log` size (if persisted)

### Capacity Planning
- **Nix Store**: Grows over time, run `nix-collect-garbage` periodically
- **Service Data**: Monitor `/srv` usage
- **Media Storage**: Monitor `tank/media` and `tank/downloads`
- **Backup Repository**: Monitor `tank/backup` (Restic handles pruning)

### System Updates
```bash
# Update flake inputs
nix flake update

# Rebuild and switch
sudo nixos-rebuild switch --flake .#thor

# Check for failures
systemctl --failed
```

## Related Documentation
- [🗄️ Storage & Shares](storage-and-shares.md) - Detailed ZFS and share configuration
- [💾 Backup & Recovery](backup-and-recovery.md) - Restic and snapshot management
- [🌐 Network Configuration](network-configuration.md) - Network architecture
- [🔙 Back to Thor Overview](README.md)

---

**Configuration Sources**:
- [`hosts/thor/default.nix`](../../hosts/thor/default.nix)
- [`hosts/thor/disko-configuration.nix`](../../hosts/thor/disko-configuration.nix)
- [`hosts/thor/hardware-configuration.nix`](../../hosts/thor/hardware-configuration.nix)
