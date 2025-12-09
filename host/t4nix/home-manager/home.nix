{
  pkgs,
  config,
  ...
}: {
  home = {
    username = "mirza";
    stateVersion = "23.11";
  };

  home.packages = with pkgs; [
    wl-clipboard
    insomnia
    jetbrains.datagrip
    discord
    mermaid-cli
    eduvpn-client
    usbutils
    zotero
    drawio
    postgresql
    postman
    obsidian
    kind
    kubectl
    kubectl-explore
    ungoogled-chromium
    burpsuite
    wireshark
    minikube
    openssl
    exiftool
    tokei
    anydesk
    slack
    dig
    fd
    nmap
    unzip
    zip
    neovim
    wget
    lz4
    age
    ssh-to-age
    sops
    vscode
    zstd
    gnumake
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
