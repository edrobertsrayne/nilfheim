# Module Templates

This document provides code templates for common module patterns in Nilfheim configuration.

## Basic Module Template

The simplest module structure for a single aspect:

```nix
# modules/{aspect}.nix
{ inputs, config, lib, pkgs, ... }: {
  # NixOS system-level config (if needed)
  flake.modules.nixos.myAspect = {
    # System services, packages, configuration
    environment.systemPackages = [ pkgs.somePackage ];
    services.someService.enable = true;
  };

  # Home-Manager user-level config (if needed)
  flake.modules.homeManager.myAspect = {
    # User programs, dotfiles, configuration
    programs.someProgram.enable = true;
    home.packages = [ pkgs.somePackage ];
  };
}
```

**When to use:** Most aspect modules that need both system and user configuration.

---

## Multi-Context Configuration Template

When a feature needs extensive configuration in both contexts:

```nix
# modules/myfeature.nix
{ inputs, config, lib, pkgs, ... }: {
  flake.modules.nixos.myFeature = {
    # System-level: services, kernel modules, system packages
    services.myService = {
      enable = true;
      port = 8080;
      settings = {
        option1 = "value1";
      };
    };

    environment.systemPackages = with pkgs; [
      myfeature-cli
    ];

    # System-wide environment variables
    environment.variables = {
      MYFEATURE_HOME = "/var/lib/myfeature";
    };
  };

  flake.modules.homeManager.myFeature = {
    # User-level: programs, dotfiles, user packages
    programs.myfeature = {
      enable = true;
      settings = {
        theme = "dark";
        editor = "nvim";
      };
    };

    # User dotfiles
    home.file.".myfeaturerc".text = ''
      # Configuration file
      setting = value
    '';

    # User packages
    home.packages = with pkgs; [
      myfeature-extras
    ];
  };
}
```

**When to use:** Features that require both system services and user configuration.

---

## Custom Options Template

For project-wide settings that other modules need to reference:

```nix
# modules/nilfheim/+myoption.nix
{ inputs, config, lib, ... }: {
  options.flake.nilfheim.myOption = {
    enable = lib.mkEnableOption "My feature";

    setting = lib.mkOption {
      type = lib.types.str;
      default = "default-value";
      description = "A configurable setting for my feature";
    };

    complexSetting = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = { key1 = "value1"; key2 = "value2"; };
      description = "Complex structured setting";
    };
  };

  config.flake.nilfheim.myOption = {
    # Default configuration can go here
    # Or leave empty and let host configs set values
  };
}
```

**Then reference in other modules:**

```nix
# modules/some-aspect.nix
{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.flake.nilfheim.myOption;
in {
  flake.modules.nixos.someAspect = lib.mkIf cfg.enable {
    # Use the custom option values
    services.something.value = cfg.setting;
  };
}
```

**When to use:** Settings that need to be shared across multiple modules or configured per-host.

---

## Aggregator Pattern Template

For grouping related features together:

```nix
# modules/desktop.nix
{ inputs, ... }: {
  flake.modules.nixos.desktop = {
    imports = with inputs.self.modules.nixos; [
      # Window manager and compositor
      hyprland

      # System services
      greetd
      pipewire

      # Desktop utilities
      clipboard
      screenshot
    ];

    # Optional: aggregator-level configuration
    # (Usually aggregators just import, but can add config)
    environment.sessionVariables = {
      # Session-wide variables for desktop
      XDG_CURRENT_DESKTOP = "Hyprland";
    };
  };

  flake.modules.homeManager.desktop = {
    imports = with inputs.self.modules.homeManager; [
      # User-level desktop apps
      nixvim
      waybar
      terminal
    ];
  };
}
```

**When to use:** Grouping related features that are commonly enabled together.

---

## Helper Function Template

For reusable library functions:

```nix
# modules/lib/myhelpers.nix
{ inputs, ... }: {
  flake.lib.myHelpers = {
    # Simple helper function
    mkSetting = value: {
      enable = true;
      setting = value;
    };

    # More complex helper
    mkModuleConfig = { name, package, settings ? {} }: {
      services.${name} = {
        enable = true;
        package = package;
      } // settings;
    };

    # Helper with multiple parameters
    mkKeybind = { key, command, description ? "" }: {
      inherit key command;
      desc = description;
    };
  };
}
```

**Then use in other modules:**

```nix
# modules/some-aspect.nix
{ inputs, config, lib, pkgs, ... }:
let
  helpers = inputs.self.lib.myHelpers;
in {
  flake.modules.nixos.someAspect = {
    services.myService = helpers.mkModuleConfig {
      name = "myService";
      package = pkgs.myPackage;
      settings = {
        port = 8080;
      };
    };
  };
}
```

**When to use:** Patterns that repeat across multiple modules.

---

## Conditional Configuration Template

For modules that should behave differently based on conditions:

```nix
# modules/development.nix
{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.flake.nilfheim.development;
  isDevMachine = config.networking.hostName == "freya";
in {
  options.flake.nilfheim.development = {
    languages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Development languages to support";
    };
  };

  flake.modules.nixos.development = {
    environment.systemPackages = with pkgs;
      # Base development tools
      [ git gh ]

      # Conditional packages based on languages
      ++ lib.optionals (lib.elem "rust" cfg.languages) [ rustc cargo ]
      ++ lib.optionals (lib.elem "python" cfg.languages) [ python3 ]
      ++ lib.optionals (lib.elem "nix" cfg.languages) [ nixd alejandra ]

      # Extra tools only on dev machines
      ++ lib.optionals isDevMachine [ gdb valgrind ];
  };
}
```

**When to use:** Configuration that varies based on host or user settings.

---

## Complex Feature Module Template

For features that need their own directory:

```nix
# modules/nixvim/default.nix
{ inputs, ... }: {
  flake.modules.homeManager.nixvim = {
    imports = [
      ./options.nix
      ./keybindings.nix
      ./lsp.nix
      ./plugins.nix
    ];

    programs.nixvim.enable = true;
  };
}
```

```nix
# modules/nixvim/options.nix
{ inputs, ... }: {
  programs.nixvim = {
    options = {
      number = true;
      relativenumber = true;
      # ... other options
    };
  };
}
```

```nix
# modules/nixvim/keybindings.nix
{ inputs, ... }: {
  programs.nixvim = {
    keymaps = [
      # ... keybindings
    ];
  };
}
```

**When to use:** Features with enough configuration to warrant multiple files.

---

## Host-Specific Configuration Template

For truly host-specific config (hardware, unique settings):

```nix
# modules/hosts/freya/default.nix
{ inputs, config, lib, pkgs, modulesPath, ... }: {
  flake.modules.nixos.hosts.freya = {
    # Import hardware-specific modules
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./hardware.nix
    ];

    # Host identity
    networking.hostName = "freya";

    # Host-specific overrides
    services.tailscale.enable = true;

    # Boot configuration
    boot.loader.systemd-boot.enable = true;
  };
}
```

```nix
# modules/hosts/freya/hardware.nix
{ config, lib, pkgs, ... }: {
  # Hardware-specific configuration
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/...";
    fsType = "ext4";
  };

  hardware.cpu.intel.updateMicrocode = true;
}
```

**When to use:** Hardware config, hostname, and truly machine-specific settings.

---

## Summary: Choosing the Right Template

| Use Case | Template | Location |
|----------|----------|----------|
| Simple aspect (SSH, Git) | Basic Module | `modules/{aspect}.nix` |
| Feature with system + user config | Multi-Context | `modules/{feature}.nix` |
| Shared settings/options | Custom Options | `modules/nilfheim/+{option}.nix` |
| Group related features | Aggregator | `modules/{group}.nix` |
| Reusable functions | Helper Function | `modules/lib/{helper}.nix` |
| Complex feature | Complex Feature | `modules/{feature}/` |
| Hardware/host-unique | Host-Specific | `modules/hosts/{hostname}/` |

## Tips

1. **Start simple** - Use Basic Module template, expand as needed
2. **One aspect per file** - Don't combine unrelated features
3. **Name by purpose** - File name describes what it configures, not how
4. **Follow existing patterns** - Look at similar modules in the codebase
5. **Remember git add** - New files must be tracked for import-tree to load them
