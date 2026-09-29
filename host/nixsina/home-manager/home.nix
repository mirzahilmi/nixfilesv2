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
  home.packages = with pkgs; [
    bat
    btop
    claude-code
    fzf
    ghostty
    gnumake
    lazygit
    librewolf
    lsd
    neovim
    nvtopPackages.nvidia
    obsidian
    tmux
    xdg-utils
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
    "${config.home.homeDirectory}/nixfilesv2/host/nixsina/home-manager/ohmyposh.json";
  xdg.configFile."tmux/tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/nixsina/home-manager/tmux.conf";
  xdg.configFile."ghostty/config".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/nixsina/home-manager/ghostty";

  xdg.configFile."ghostty/shaders" = {
    recursive = true;
    source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixfilesv2/host/t4nix/home-manager/ghostty_shaders";
  };
}
