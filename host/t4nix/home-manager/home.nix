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
    anydesk
    bat
    burpsuite
    chafa
    chromium
    dig
    drawio
    eduvpn-client
    exiftool
    fd
    gnumake
    hwinfo
    insomnia
    inxi
    jetbrains.datagrip
    kdePackages.kclock
    kind
    kubectl
    kubectl-explore
    live-server
    lz4
    mermaid-cli
    minikube
    neovim
    nmap
    obsidian
    open-github
    openssl
    postgresql
    postman
    release-please
    rendercv
    slack
    sops
    ssh-to-age
    systemPackages.inter
    systemPackages.nerd-fonts.iosevka-term
    teams-for-linux
    tokei
    unstable.biome # fix https://github.com/biomejs/biome/issues/6623
    unzip
    usbutils
    vscode
    wget
    wireshark
    wl-clipboard
    yazi
    zip
    zotero
    zstd
  ];

  xdg.configFile."ghostty/config".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/t4nix/home-manager/ghostty";
  xdg.configFile."oh-my-posh/config.json".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/t4nix/home-manager/ohmyposh.json";
  xdg.configFile."yazi/keymap.toml".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/t4nix/home-manager/yazi_keymap.toml";

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

  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
}
