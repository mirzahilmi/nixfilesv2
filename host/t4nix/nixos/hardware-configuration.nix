{
  config,
  lib,
  modulesPath,
  secrets,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = secrets.disk-by-uuid.t4nix.nixos;
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = secrets.disk-by-uuid.t4nix.boot;
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      devices = ["nodev"];
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 5;
      minegrub-theme = {
        enable = true;
        splash = "Lowkirkenuinely, i'm happy :)";
        background = "background_options/1.19 - [The Wild Update].png";
        boot-options-count = 4;
      };
    };
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  hardware.bluetooth.enable = true;
  networking.nftables.enable = true;
}
