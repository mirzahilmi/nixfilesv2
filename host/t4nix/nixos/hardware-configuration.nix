{
  config,
  lib,
  modulesPath,
  secrets,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = secrets.disk-by-uuid.t4nix.nixos;
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = secrets.disk-by-uuid.t4nix.boot;
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  hardware.bluetooth.enable = true;
  networking.nftables.enable = true;
}
