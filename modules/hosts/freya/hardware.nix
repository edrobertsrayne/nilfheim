_: {
  flake.modules.nixos.freya = {
    config,
    lib,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
      initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod"];
      initrd.kernelModules = ["dm-snapshot"];
      kernelModules = ["kvm-intel"];
      extraModulePackages = [];
    };

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
