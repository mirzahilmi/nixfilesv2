{pkgs, ...}: {
  wsl = {
    enable = true;
    defaultUser = "nixos";
    wslConf.network.hostname = "carefull";
  };

  users.extraUsers."nixos" = {
    isNormalUser = true;
    packages = with pkgs; [
      gnumake
      systemPackages.home-manager
    ];
    shell = pkgs.systemPackages.zsh;
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    nh
    vim
  ];

  system.stateVersion = "25.11";
}
