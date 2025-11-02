{inputs, ...}: let
  inherit (inputs.self.nilfheim.user) username;
in {
  flake.modules = {
    nixos.zsh = {pkgs, ...}: {
      programs.zsh.enable = true;
      users.users.${username}.shell = pkgs.zsh;
      home-manager.users.${username}.imports = [inputs.self.modules.homeManager.zsh];
    };

    darwin.zsh = {pkgs, ...}: {
      programs.zsh.enable = true;
      users.users.${username}.shell = pkgs.zsh;
    };

    homeManager.zsh = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
      };
    };
  };
}
