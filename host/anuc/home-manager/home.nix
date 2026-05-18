{
  pkgs,
  secrets,
  ...
}: {
  home = {
    username = secrets.user.secondary.username;
    stateVersion = "23.11";
  };

  home.packages = with pkgs; [
    btop
    fastfetch
    gnumake
    k6
    lz4
    neovim
    nmap
    zstd
  ];

  programs.tmux = {
    enable = true;
    secureSocket = true;
    extraConfig = builtins.readFile ./tmux.conf;
    plugins = builtins.attrValues {
      inherit (pkgs.tmuxPlugins) fingers;
    };
  };
}
