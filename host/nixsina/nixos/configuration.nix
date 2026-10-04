{
  pkgs,
  secrets,
  ...
}: {
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

  security.rtkit.enable = true;
  programs = {
    zsh.enable = true;
    nix-ld.enable = true;
    nh = {
      enable = true;
      flake = "/home/${secrets.user.primary.username}/nixfilesv2";
    };
  };

  services.pipewire = {
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
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
  };

  services = {
    desktopManager.plasma6.enable = true;
    tailscale.enable = true;
    displayManager.sddm.enable = true;
    cloudflare-warp.enable = true;
  };
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    discover
    elisa
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      backgroundColor = "#000000";
    };
  };

  time.timeZone = "Asia/Jakarta";
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "en_GB.UTF-8/UTF-8"];

  services.openssh.enable = true;

  users.users."${secrets.user.primary.username}" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = [pkgs.home-manager];
    shell = pkgs.zsh;
  };

  environment.sessionVariables.EDITOR = "nvim";

  services.xserver.videoDrivers = ["nvidia"];
  # see https://github.com/tailscale/tailscale/issues/4254#issuecomment-1075318898
  services.resolved.enable = true;

  hardware.bluetooth.enable = true;
}
