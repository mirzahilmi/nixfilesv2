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
    extraGroups = [
      "wheel"
      "audio"
      "docker"
    ];
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
    throttled.enable = true;
  };

  # Fingerprint
  services."06cb-009a-fingerprint-sensor" = {
    enable = true;
    backend = "libfprint-tod";
    calib-data-file = "${builtins.toString inputs.nixsecrets}/${secrets.filepath.t4nix-fprint}";
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
    vim
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
  };

  environment.sessionVariables.EDITOR = "nvim";

  nix-mineral = {
    enable = true;
    filesystems.normal = {
      "/home".options.noexec = false;
      "/tmp".options.noexec = false;
    };
  };
}
