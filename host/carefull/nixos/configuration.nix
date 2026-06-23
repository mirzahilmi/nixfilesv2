{pkgs, ...}: {
  wsl = {
    enable = true;
    defaultUser = "nixos";
    wslConf.network.hostname = "carefull";
  };

  users.extraUsers."nixos" = {
    isNormalUser = true;
    shell = pkgs.systemPackages.zsh;
    extraGroups = ["wheel" "docker"];
    packages = with pkgs; [
      gnumake
      systemPackages.home-manager
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    nh
    vim
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
  };

  networking.extraHosts = ''
    172.17.0.1 host.docker.internal
  '';

  programs.nix-ld.enable = true;

  system.stateVersion = "25.11";
}
