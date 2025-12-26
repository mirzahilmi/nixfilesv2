{
  pkgs,
  config,
  ...
}: {
  home = {
    username = "hilmi";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "23.11";
  };

  home.packages = with pkgs; [
    neovim
    k6
    btop
    fastfetch
    lz4
    nmap
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
