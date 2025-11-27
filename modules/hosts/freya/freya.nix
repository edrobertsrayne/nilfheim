{inputs, ...}: let
  inherit (inputs.self.niflheim.user) username;
in {
  flake.modules.nixos.freya = {
    imports =
      [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
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

    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    programs.nix-ld.enable = true;

    users.users.${username}.extraGroups = ["dialout"];
  };

  flake.modules.homeManager.freya = {pkgs, ...}: {
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
      firefox.enable = true;
      vscode.enable = true;
      zathura.enable = true;
      chromium = {
        enable = true;
        package = pkgs.google-chrome;
      };
    };

    home.packages = with pkgs; [
      bambu-studio
      discord
    ];
  };
}
