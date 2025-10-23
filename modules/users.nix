{
  flake.modules.nixos.users = { pkgs, lib, ... }: {
    # Define user account
    users.users.ed = {
      isNormalUser = true;
      description = "Ed";
      extraGroups = [ "wheel" "networkmanager" ];
      initialPassword = "password";
      packages = with pkgs; [
        vim
        git
        htop
      ];
    };

    # Enable sudo for wheel group
    security.sudo.wheelNeedsPassword = lib.mkDefault true;
  };
}
