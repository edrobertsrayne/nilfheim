{inputs, ...}: {
  flake.modules.nixos.freya = {
    imports = with inputs.self.modules.nixos; [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
      zsh
      greetd
      audio
      hyprland
      bluetooth
    ];

    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    programs.nix-ld.enable = true;
  };

  flake.modules.homeManager.freya = {pkgs, ...}: {
    imports = with inputs.self.modules.homeManager; [
      starship
      utilities
      neovim
      obsidian
      spicetify
      python
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
  };
}
