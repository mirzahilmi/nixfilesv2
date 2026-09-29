{
  pkgs,
  lib,
  secrets,
  ...
}: {
  nix.settings = {
    substituters = [
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  networking = {
    hostName = "nixsina";
    networkmanager = {
      enable = true;
      # see https://github.com/NixOS/nixpkgs/issues/424326#issuecomment-3062893416
      plugins = with pkgs; [networkmanager-openvpn];
    };
    nameservers = [secrets.nameserver.default];
  };
  system.stateVersion = "23.11";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  programs = {
    zsh.enable = true;
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld;
    };
    nh = {
      enable = true;
      flake = "/home/${secrets.user.primary.username}/nixfilesv2";
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  fonts.packages = builtins.attrValues {
    inherit
      (pkgs)
      ibm-plex
      times-newer-roman
      ;
    inherit
      (pkgs.nerd-fonts)
      blex-mono
      iosevka
      iosevka-term
      ;
  };

  console = {
    packages = [pkgs.terminus_font];
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    keyMap = "us";
  };

  services = {
    desktopManager.plasma6.enable = true;
    tailscale.enable = true;
    displayManager.gdm.enable = true;
    cloudflare-warp.enable = true;
  };
  services.packagekit.enable = false;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    discover
    elisa
  ];

  boot.loader = {
    timeout = 5;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      backgroundColor = "#000000";
    };
  };

  time.timeZone = lib.mkDefault "Asia/Jakarta";
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    supportedLocales = lib.mkDefault ["en_US.UTF-8/UTF-8" "en_GB.UTF-8/UTF-8"];
  };

  services.openssh.enable = true;
  # networking = {
  #   interfaces.eno1.ipv4.addresses = [
  #     {
  #       address = "10.34.239.139";
  #       prefixLength = 23;
  #     }
  #   ];
  #   defaultGateway = {
  #     address = "10.34.238.1";
  #     interface = "eno1";
  #   };
  # };

  # services.logind.lidSwitch = "lock";
  # services.xserver.displayManager.gdm.autoSuspend = false;

  users.extraUsers."${secrets.user.primary.username}" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "docker"
    ];
    packages = [pkgs.home-manager];
    shell = pkgs.zsh;
  };

  environment.sessionVariables.EDITOR = "nvim";

  services.xserver.videoDrivers = ["nvidia"];
  # see https://github.com/tailscale/tailscale/issues/4254#issuecomment-1075318898
  services.resolved.enable = true;
}
