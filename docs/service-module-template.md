# Service Module Template

This document provides standardized patterns for creating consistent service modules in the nilfheim configuration.

## Standard Service Module Structure

```nix
{
  config,
  lib,
  pkgs,
  nilfheim,
  ...
}:
with lib; let
  inherit (nilfheim) constants;
  cfg = config.services.SERVICE_NAME;
in {
  options.services.SERVICE_NAME = {
    # Standard URL option for proxy services
    url = mkOption {
      type = types.str;
      default = "SERVICE_NAME.${config.homelab.domain}";
      description = "URL for SERVICE_NAME proxy host.";
    };

    # Standard port option (if service needs custom port)
    port = mkOption {
      type = types.port;
      default = constants.ports.SERVICE_NAME;
      description = "Port for SERVICE_NAME service to listen on.";
    };

    # Add service-specific options here with proper descriptions
    customOption = mkOption {
      type = types.str;
      default = "defaultValue";
      description = "Clear explanation of what this option does.";
    };
  };

  config = mkIf cfg.enable {
    # Service configuration
    services.SERVICE_NAME = {
      # Service-specific configuration
    };

    # Homepage dashboard integration
    services.homepage-dashboard.homelabServices = [
      {
        group = "ServiceGroup";
        name = "Service Name";
        entry = {
          href = "https://${cfg.url}";
          icon = "service-icon.svg";
          siteMonitor = "https://${cfg.url}";
          description = "Brief service description";
        };
      }
    ];

    # Nginx proxy configuration
    services.nginx.virtualHosts."${cfg.url}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        inherit (constants.nginxDefaults) proxyWebsockets;
      };
    };

    # Additional configuration (firewall, users, etc.)
  };
}
```

## Service Module Patterns

### 1. Basic Service Pattern
For simple services that only need enable/disable:
- No custom options needed
- Use existing NixOS service options
- Standard homepage integration

### 2. Proxy Service Pattern
For services behind nginx proxy:
- Standard `url` option
- Optional `port` option if configurable
- Nginx proxy configuration with constants.nginxDefaults
- Homepage integration

### 3. Complex Service Pattern
For services with multiple configuration options:
- Multiple custom options with descriptions
- Database integration if needed
- Secret management with agenix
- Advanced networking/firewall rules

## Required Elements

### Option Descriptions
Every custom option MUST have a description:
```nix
someOption = mkOption {
  type = types.str;
  default = "value";
  description = "Clear explanation of what this option does.";
};
```

### Proper Types
Use appropriate NixOS types:
- `types.str` for strings
- `types.port` for ports
- `types.bool` for booleans
- `types.int` for integers
- `types.listOf` for lists
- `types.path` for filesystem paths

### URL Option Standard
For services with web interfaces:
```nix
url = mkOption {
  type = types.str;
  default = "service-name.${config.homelab.domain}";
  description = "URL for service-name proxy host.";
};
```

### Port Option Standard
For services with configurable ports:
```nix
port = mkOption {
  type = types.port;
  default = constants.ports.serviceName;
  description = "Port for service to listen on.";
};
```

## Best Practices

### Constants Usage
- Use `nilfheim` namespace for library access (never relative imports)
- Use `inherit (nilfheim) constants;` in let bindings
- Use `constants.ports.serviceName` for port defaults
- Reference `constants.nginxDefaults` for proxy settings

### Naming Conventions
- Use kebab-case for service names in URLs
- Use camelCase for constants.ports entries
- Use descriptive option names

### Documentation
- Every option needs a clear description
- Explain what the option affects
- Include units or constraints where relevant

### Error Prevention
- Use proper types to catch configuration errors
- Set sensible defaults
- Add validation where beneficial

## Examples

### Simple Service (jellyfin.nix)
```nix
# Has URL option, uses constants for ports, standard proxy setup
```

### Complex Service (karakeep.nix)
```nix
# Multiple options, port configuration, environment variables
```

### Service Without Options (code-server.nix - before fix)
```nix
# Example of what to avoid - hardcoded values, no options
```

This template should be used as a reference for maintaining consistency across all service modules.