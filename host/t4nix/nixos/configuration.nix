{
  inputs,
  pkgs,
  secrets,
  ...
}: {
  networking = {
    hostName = "t4nix";
    networkmanager = {
      enable = true;
      # see https://github.com/NixOS/nixpkgs/issues/424326#issuecomment-3062893416
      plugins = with pkgs; [networkmanager-openvpn];
    };
    nameservers = [secrets.nameserver.default];
  };
  system.stateVersion = "23.11";

  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    packages = [pkgs.systemPackages.terminus_font];
    earlySetup = true;
    font = "${pkgs.systemPackages.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    keyMap = "us";
  };

  users.extraUsers."${secrets.user.primary.username}" = {
    isNormalUser = true;
    extraGroups = secrets.user.primary.groups;
    packages = [pkgs.systemPackages.home-manager];
    shell = pkgs.systemPackages.zsh;
  };

  services = {
    desktopManager.plasma6.enable = true;
    tailscale.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true; # explicit
    };
    cloudflare-warp.enable = true;
  };
  services.packagekit.enable = false;
  environment.plasma6.excludePackages = with pkgs.systemPackages.kdePackages; [
    discover
    elisa
  ];

  # Fingerprint
  services."06cb-009a-fingerprint-sensor" = {
    enable = true;
    backend = "libfprint-tod";
    calib-data-file = "${toString inputs.nixsecrets}/${secrets.filepath.t4nix-fprint}";
  };
  # systemd.services.fprintd.serviceConfig.ExecStartPre = "/usr/bin/env sleep 2";
  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="06cb", \
  #   ATTR{idProduct}=="009a", TEST=="power/autosuspend", \
  #   ATTR{power/autosuspend}="-1"
  # '';

  # services.howdy = {
  #   enable = true;
  #   package = pkgs.unstable.howdy;
  #   control = "sufficient";
  #   settings.video.device_path = "/dev/video0";
  # };

  services.throttled = {
    enable = true;
    extraConfig = ''
      [UNDERVOLT]
      # CPU core voltage offset (mV)
      CORE: -105
      # Integrated GPU voltage offset (mV)
      GPU: -85
      # CPU cache voltage offset (mV)
      CACHE: -105
      # System Agent voltage offset (mV)
      UNCORE: -85
      # Analog I/O voltage offset (mV)
      ANALOGIO: 0
    '';
  };

  programs = {
    nix-ld = {
      enable = true;
      package = pkgs.systemPackages.nix-ld;
    };
    wireshark.enable = true;
    mtr.enable = true;
    zsh.enable = true;
    nh = {
      enable = true;
      flake = "/home/${secrets.user.primary.username}/nixfilesv2";
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    vim
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
  };
}
