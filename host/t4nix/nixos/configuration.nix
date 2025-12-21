{
  outputs,
  pkgs,
  ...
}: {
  networking = {
    hostName = "t4nix";
    networkmanager = {
      enable = true;
      # see https://github.com/NixOS/nixpkgs/issues/424326#issuecomment-3062893416
      plugins = with pkgs; [networkmanager-openvpn];
    };
  };
  system.stateVersion = "23.11";

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  nix.settings = {
    experimental-features = toString ["nix-command" "flakes"];
    trusted-users = ["mirza"];

    # see https://nix-community.org/cache/
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  fonts.packages = builtins.attrValues {
    inherit (pkgs.systemPackages) inter;
    inherit
      (pkgs.systemPackages.nerd-fonts)
      blex-mono
      iosevka-term
      ;
  };

  console = {
    packages = [pkgs.systemPackages.terminus_font];
    earlySetup = true;
    font = "${pkgs.systemPackages.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    keyMap = "us";
  };

  users.extraUsers."mirza" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "docker"
    ];
    packages = [pkgs.systemPackages.home-manager];
    shell = pkgs.systemPackages.zsh;
    initialHashedPassword = "$y$j9T$RwSoFjVgi9n8Z39M.gM5A1$dltIzzH55NZpQlmwyU.Py.qWyfFW72v6Ppq/QMFFc60";
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

  programs = {
    nix-ld = {
      enable = true;
      package = pkgs.systemPackages.nix-ld;
    };
    wireshark.enable = true;
    mtr.enable = true;
    nh.enable = true;
    zsh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    gnumake

    (systemPackages.where-is-my-sddm-theme.override {
      themeConfig.General = {
        passwordCharacter = "*";
        passwordMask = true;
        passwordInputWidth = 0.5;
        passwordInputBackground = "";
        passwordInputRadius = "";
        passwordInputCursorVisible = true;
        passwordFontSize = 96;
        passwordTextColor = "";
        showSessionsByDefault = false;
        sessionsFontSize = 24;
        showUsersByDefault = false;
        usersFontSize = 48;
        background = "";
        backgroundFill = "#0E0E10";
        backgroundFillMode = "aspect";
        basicTextColor = "#F9F6EE";
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
