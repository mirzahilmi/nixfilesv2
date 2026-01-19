{
  config,
  lib,
  pkgs,
  modulesPath,
  secrets,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  boot.kernel.sysctl = {
    # see https://grafana.com/docs/k6/latest/testing-guides/running-large-tests/#os-fine-tuning
    "net.ipv4.ip_local_port_range" = "1024 65535";
    "net.ipv4.tcp_tw_reuse" = 1;
    "net.ipv4.tcp_timestamps" = 1;
  };

  fileSystems."/" = {
    device = secrets.disk-by-uuid.anuc.nixos;
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = secrets.disk-by-uuid.anuc.boot;
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [{device = secrets.disk-by-uuid.anuc.swap;}];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
