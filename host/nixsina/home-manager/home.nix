{
  pkgs,
  config,
  secrets,
  ...
}: {
  home = {
    username = secrets.user.primary.username;
    stateVersion = "23.11";
  };

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; let
    python3 = pkgs.python3.withPackages (ps: with ps; [defusedxml lxml]);
  in [
    bat
    brave
    btop
    claude-code
    eduvpn-client
    fd
    ffmpeg-headless
    fzf
    gh
    ghostty
    gnumake
    kubectl
    lazygit
    libreoffice
    librewolf
    lsd
    neovim
    nodejs
    nvtopPackages.nvidia
    obsidian
    pandoc
    pnpm
    poppler-utils
    python3
    smartmontools
    sofka
    tmux
    unzip
    uv
    xdg-utils
    zip
    zoxide
    zstd

    nerd-fonts.iosevka-term
  ];

  # fix: Existing file '/home/mirza/.config/mimeapps.list' would be clobbered
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    # see https://mimetype.io/all-types
    defaultApplications = {
      "x-scheme-handler/http" = ["librewolf.desktop"];
      "x-scheme-handler/https" = ["librewolf.desktop"];
      "x-scheme-handler/ftp" = ["librewolf.desktop"];
      "text/html" = ["librewolf.desktop"];
      "application/xhtml+xml" = ["librewolf.desktop"];
      "application/pdf" = ["librewolf.desktop"];
      "text/uri-list" = ["librewolf.desktop"];
      "application/x-extension-htm" = ["librewolf.desktop"];
      "application/x-extension-html" = ["librewolf.desktop"];
      "application/x-extension-shtml" = ["librewolf.desktop"];
      "application/x-extension-xhtml" = ["librewolf.desktop"];
      "application/x-extension-xht" = ["librewolf.desktop"];
    };
  };

  xdg.configFile."oh-my-posh/config.json".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/nixsina/config.d/ohmyposh.json";
  xdg.configFile."tmux/tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/nixsina/config.d/tmux.conf";
  xdg.configFile."ghostty/config".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/nixsina/config.d/ghostty";

  xdg.configFile."ghostty/shaders" = {
    recursive = true;
    source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixfilesv2/host/t4nix/home-manager/ghostty_shaders";
  };
}
