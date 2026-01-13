{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "ahci" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2478cfbf-67cb-429b-8e0f-640cbe98b4ea";
    fsType = "btrfs";
    options = ["subvol=root"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/2478cfbf-67cb-429b-8e0f-640cbe98b4ea";
    fsType = "btrfs";
    options = ["subvol=nix"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/2478cfbf-67cb-429b-8e0f-640cbe98b4ea";
    fsType = "btrfs";
    options = ["subvol=persist"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9309-C1FD";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/aa02a4fd-ef38-4ff6-a456-d52212d4ef46";}
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.graphics.enable = true;
}
