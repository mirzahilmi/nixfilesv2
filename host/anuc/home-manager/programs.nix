{
  programs.tmux = {
    enable = true;
    secureSocket = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
