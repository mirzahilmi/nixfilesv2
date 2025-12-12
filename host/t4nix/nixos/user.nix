{pkgs, ...}: {
  users.extraUsers."mirza" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "docker"
    ];
    packages = [pkgs.systemPackages.home-manager];
    shell = pkgs.systemPackages.zsh;
    initialHashedPassword = "$y$j9T$RwSoFjVgi9n8Z39M.gM5A1$dltIzzH55NZpQlmwyU.Py.qWyfFW72v6Ppq/QMFFc60";
  };
  programs.zsh.enable = true;
}
