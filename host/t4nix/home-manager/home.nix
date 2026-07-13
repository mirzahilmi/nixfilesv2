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
    delta
    dig
    eduvpn-client
    fastfetch
    fd
    fzf
    gnumake
    jq
    k9s
    kind
    kubectl
    kubectl-explore
    lazygit
    lsd
    lz4
    mermaid-cli
    mitmproxy
    neovim
    nmap
    open-github
    openssl
    python3
    ripgrep
    sops
    ssh-to-age
    tealdeer
    unzip
    uv
    wget
    wl-clipboard
    zip
    zoxide
    zstd

    chromium
    drawio
    ghostty
    insomnia
    jetbrains.datagrip
    librewolf
    obsidian
    # wireshark
    zathura
    zotero

    inter
    nerd-fonts.iosevka-term
    nerd-fonts.lilex

    claude-code
    # unstable.rendercv
    unstable.rtk
  ];

  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/t4nix/home-manager/claude_settings.json";

  xdg.configFile."ghostty/config".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/t4nix/home-manager/ghostty";
  xdg.configFile."oh-my-posh/config.json".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/t4nix/home-manager/ohmyposh.json";
  xdg.configFile."btop/btop.conf".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/t4nix/home-manager/btop.conf";
  xdg.configFile."lazygit/config.yml".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/t4nix/home-manager/lazygit.yaml";
  xdg.configFile."k9s/skins/transparent.yaml".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/t4nix/home-manager/k9s_transparent.yaml";

  xdg.configFile."ghostty/shaders" = {
    recursive = true;
    source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixfilesv2/host/t4nix/home-manager/ghostty_shaders";
  };

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

  dconf.settings = {"org/gnome/desktop/interface".color-scheme = "prefer-dark";};
}
