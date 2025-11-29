_: {
  flake.modules.homeManager.vscodium = {pkgs, ...}: {
    # stylix.targets.vscode.enable = false;
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
    };
  };
}
