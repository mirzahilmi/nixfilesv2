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
    enable = false;
    # copied over from https://github.com/erpalma/throttled/blob/master/etc/throttled.conf
    # with replaced section from https://github.com/erpalma/throttled#configuration
    extraConfig = ''
      [GENERAL]
      # Enable or disable the script execution
      Enabled: True
      # SYSFS path for checking if the system is running on AC power
      Sysfs_Power_Path: /sys/class/power_supply/AC*/online
      # Auto reload config on changes
      Autoreload: True

      ## Settings to apply while connected to Battery power
      [BATTERY]
      # Update the registers every this many seconds
      Update_Rate_s: 30
      # Max package power for time window #1
      PL1_Tdp_W: 29
      # Time window #1 duration
      PL1_Duration_s: 28
      # Max package power for time window #2
      PL2_Tdp_W: 44
      # Time window #2 duration
      PL2_Duration_S: 0.002
      # Max allowed temperature before throttling
      Trip_Temp_C: 85
      # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
      cTDP: 0
      # Disable BDPROCHOT (EXPERIMENTAL)
      Disable_BDPROCHOT: False

      ## Settings to apply while connected to AC power
      [AC]
      # Update the registers every this many seconds
      Update_Rate_s: 5
      # Max package power for time window #1
      PL1_Tdp_W: 44
      # Time window #1 duration
      PL1_Duration_s: 28
      # Max package power for time window #2
      PL2_Tdp_W: 44
      # Time window #2 duration
      PL2_Duration_S: 0.002
      # Max allowed temperature before throttling
      Trip_Temp_C: 95
      # Set HWP energy performance hints to 'performance' on high load (EXPERIMENTAL)
      # Uncomment only if you really want to use it
      # HWP_Mode: False
      # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
      cTDP: 0
      # Disable BDPROCHOT (EXPERIMENTAL)
      Disable_BDPROCHOT: False

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

      # [ICCMAX.AC]
      # # CPU core max current (A)
      # CORE:
      # # Integrated GPU max current (A)
      # GPU:
      # # CPU cache max current (A)
      # CACHE:

      # [ICCMAX.BATTERY]
      # # CPU core max current (A)
      # CORE:
      # # Integrated GPU max current (A)
      # GPU:
      # # CPU cache max current (A)
      # CACHE:
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

  # NOTE:
  # fix WiFi-UB.x can't connect
  # nmcli connection modify WiFi-UB.x 802-1x.phase1-auth-flags 32
}
