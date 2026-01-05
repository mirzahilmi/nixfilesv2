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

  fonts.packages = builtins.attrValues {
    inherit (pkgs.systemPackages) inter;
    inherit
      (pkgs.systemPackages.nerd-fonts)
      iosevka-term
      ;
  };

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
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "where_is_my_sddm_theme";
      settings.General.DisplayServer = "wayland";
    };
    cloudflare-warp.enable = true;
  };
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

    (systemPackages.where-is-my-sddm-theme.override {
      themeConfig.General = {
        passwordCharacter = "*";
        passwordMask = true;
        passwordInputWidth = 0.5;
        passwordInputBackground = "";
        passwordInputRadius = "";
        passwordInputCursorVisible = true;
        passwordFontSize = 96;
        passwordTextColor = "#0E0E10";
        passwordCursorColor = "#0E0E10";
        passwordAllowEmpty = true;

        showSessionsByDefault = false;
        sessionsFontSize = 24;
        showUsersByDefault = false;
        usersFontSize = 48;

        background = "";
        backgroundFill = "#F9F6EE";
        backgroundFillMode = "aspect";
        basicTextColor = "#0E0E10";
        blurRadius = "";
      };
    })
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
  };

  environment.sessionVariables.EDITOR = "nvim";
}
