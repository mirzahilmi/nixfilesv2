{
  pkgs,
  lib,
  secrets,
  ...
}: {
  networking.hostName = "nixsina";
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  programs = {
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

  desktop.gnome = {
    enable = true;
    excludePackages = builtins.attrValues {
      inherit
        (pkgs)
        atomix
        cheese
        epiphany
        geary
        gedit
        gnome-contacts
        gnome-maps
        gnome-music
        gnome-terminal
        gnome-text-editor
        gnome-tour
        hitori
        iagno
        tali
        xterm
        yelp
        ;
    };
  };

  boot.loader = {
    timeout = 5;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      theme = pkgs.grubThemes.fallout;
      backgroundColor = "#000000";
    };
  };

  time.timeZone = lib.mkDefault "Asia/Jakarta";
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    supportedLocales = lib.mkDefault ["en_US.UTF-8/UTF-8" "en_GB.UTF-8/UTF-8"];
  };

  services.openssh.enable = true;
  networking = {
    defaultGateway = "10.34.238.1";
    nameservers = [
      "10.34.0.53"
      "175.45.184.73"
      "175.45.184.165"
    ];
    interfaces.eno1.ipv4.addresses = [
      {
        address = "10.34.239.56";
        prefixLength = 23;
      }
    ];
  };

  services.logind.lidSwitch = "lock";
  services.xserver.displayManager.gdm.autoSuspend = false;

  users.extraUsers."${secrets.user.primary.username}" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "docker"
    ];
    packages = [pkgs.systemPackages.home-manager];
    shell = pkgs.systemPackages.bash;
  };

  environment.sessionVariables.EDITOR = "nvim";

  services.xserver.videoDrivers = ["nvidia"];
}
