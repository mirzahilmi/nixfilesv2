{
  pkgs,
  config,
  ...
}: {
  home = {
    username = "nixos";
    stateVersion = "23.11";
  };

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    awscli2
    bat
    btop
    claude-code
    delta
    dig
    fastfetch
    fd
    ffmpeg-headless
    fzf
    gh
    jq
    k9s
    kubectl
    kubectl-explore
    lazydocker
    lazygit
    lsd
    lz4
    mermaid-cli
    mitmproxy
    neovim
    nodejs-slim
    open-github
    openssl
    postgresql # andai waktu bisa ngasih psql & pgbench doang
    python3
    ripgrep
    uv
    xdg-open
    yt-dlp
    zoxide
    zstd

    unstable.rtk
  ];

  xdg.configFile."oh-my-posh/config.json".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/carefull/home-manager/ohmyposh.json";
  xdg.configFile."lazygit/config.yml".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/carefull/home-manager/lazygit.yaml";
}
