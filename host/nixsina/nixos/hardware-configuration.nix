{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.kernelModules = ["kvm-amd" "nvidia_uvm"];
  boot.extraModulePackages = [];

  networking.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.graphics.enable = true;
  hardware.nvidia = {
    # See https://github.com/TLATER/dotfiles/blob/master/nixos-config/hosts/yui/nvidia/default.nix
    nvidiaSettings = false;
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "565.57.01";
      sha256_64bit = "sha256-buvpTlheOF6IBPWnQVLfQUiHv4GcwhvZW3Ks0PsYLHo=";
      sha256_aarch64 = lib.fakeHash;
      openSha256 = "sha256-/tM3n9huz1MTE6KKtTCBglBMBGGL/GOHi5ZSUag4zXA=";
      settingsSha256 = lib.fakeHash;
      persistencedSha256 = lib.fakeHash;
    };
  };
}
