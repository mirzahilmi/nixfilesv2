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

  home.packages = with pkgs; [
    age
    anydesk
    bat
    burpsuite
    dig
    discord
    drawio
    eduvpn-client
    exiftool
    fd
    gnumake
    insomnia
    jetbrains.datagrip
    kind
    kubectl
    kubectl-explore
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
    slack
    sops
    ssh-to-age
    tokei
    ungoogled-chromium
    unzip
    usbutils
    vscode
    wget
    wireshark
    wl-clipboard
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
