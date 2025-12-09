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
    neovim-git
    k6
    btop
    fastfetch
    lz4
    nmap
    zstd
    gnumake
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
