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
    fd
    lazygit
    lsd
    neovim
    ripgrep
  ];

  xdg.configFile."oh-my-posh/config.json".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/t6dweasel/home-manager/ohmyposh.json";
}
