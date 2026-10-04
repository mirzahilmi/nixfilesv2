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
    btop
    claude-code
    eduvpn-client
    fd
    ffmpeg-headless
    fzf
    gh
    ghostty
    gnumake
    helium
    kubectl
    lazygit
    libreoffice
    librewolf
    lsd
    neovim
    nodejs
    nvtopPackages.nvidia
    obs-studio
    obsidian
    pandoc
    pnpm
    poppler-utils
    python3
    ripgrep
    smartmontools
    sofka
    tmux
    unzip
    uv
    xdg-utils
    zip
    zoxide
    zstd

    frozen.haruna

    nerd-fonts.iosevka-term
  ];

  # fix: Existing file '/home/mirza/.config/mimeapps.list' would be clobbered
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    # see https://mimetype.io/all-types
    defaultApplications = {
      "x-scheme-handler/http" = ["helium.desktop"];
      "x-scheme-handler/https" = ["helium.desktop"];
      "x-scheme-handler/ftp" = ["helium.desktop"];
      "text/html" = ["helium.desktop"];
      "application/xhtml+xml" = ["helium.desktop"];
      "application/pdf" = ["helium.desktop"];
      "text/uri-list" = ["helium.desktop"];
      "application/x-extension-htm" = ["helium.desktop"];
      "application/x-extension-html" = ["helium.desktop"];
      "application/x-extension-shtml" = ["helium.desktop"];
      "application/x-extension-xhtml" = ["helium.desktop"];
      "application/x-extension-xht" = ["helium.desktop"];
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
