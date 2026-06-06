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
    age
    android-tools
    bat
    btop
    chafa
    delta
    dig
    dive
    eduvpn-client
    exiftool
    fastfetch
    fd
    fzf
    gnumake
    hwinfo
    inxi
    jq
    k9s
    kind
    kubectl
    kubectl-explore
    lazygit
    libmbim
    live-server
    lsd
    lz4
    mermaid-cli
    mitmproxy
    neovim
    nmap
    open-github
    openssl
    pciutils
    release-please
    ripgrep
    sops
    ssh-to-age
    tealdeer
    tokei
    unzip
    usbutils
    wget
    wl-clipboard
    zip
    zoxide
    zstd

    guiPackages.bitwarden-desktop
    guiPackages.chromium
    guiPackages.discord
    guiPackages.drawio
    guiPackages.ghostty
    guiPackages.haruna
    guiPackages.insomnia
    guiPackages.jetbrains.datagrip
    guiPackages.kdePackages.kclock
    guiPackages.libreoffice-qt
    guiPackages.librewolf
    guiPackages.obsidian
    guiPackages.parabolic
    guiPackages.postman
    guiPackages.slack
    guiPackages.vscode
    guiPackages.wireshark
    guiPackages.zotero

    systemPackages.inter
    systemPackages.nerd-fonts.iosevka-term
    systemPackages.nerd-fonts.lilex

    unstable.biome # fix https://github.com/biomejs/biome/issues/6623
    unstable.claude-code
    unstable.opencode
    unstable.rendercv
    unstable.rtk
  ];

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
