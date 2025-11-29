{inputs, ...}: {
  flake.modules.nixos.odin = {
    lib,
    pkgs,
    ...
  }: {
    imports =
      [
        inputs.nixos-hardware.nixosModules.apple-imac-18-2
      ]
      ++ (with inputs.self.modules.nixos; [
        zsh
        greetd
        audio
        hyprland
        bluetooth
        gaming
        libvirt
      ]);

    # Override to prevent conflict between nixos-hardware legacy and gaming module versions
    hardware.graphics.extraPackages = lib.mkForce (with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
      intel-compute-runtime
      vpl-gpu-rt
    ]);

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        grub.enable = lib.mkForce false;
      };
      kernelParams = ["mem_sleep_default=s2idle"];
    };

    systemd.sleep.extraConfig = ''
      SuspendState=freeze
    '';

    services.logind.settings.Login = {
      HandlePowerKey = "suspend";
    };

    services.auto-cpufreq = {
      enable = true;
      settings = {
        charger = {
          governor = "ondemand";
          turbo = "auto";
        };
      };
    };
  };

  flake.modules.homeManager.odin = {pkgs, ...}: {
    imports = with inputs.self.modules.homeManager; [
      starship
      utilities
      neovim
      obsidian
      spicetify
      python
      ghostty
      cava
    ];

    programs = {
      vscode = {
        enable = true;
        package = pkgs.vscodium;
      };
      zathura.enable = true;
      chromium = {
        enable = true;
        package = pkgs.google-chrome;
      };
    };

    wayland.windowManager.hyprland.settings = {
      monitor = ["eDP-1, preferred, auto, auto"];
      env = ["GDK_SCALE,2"];
    };

    home.packages = with pkgs; [
      bambu-studio
      discord
    ];
  };
}
