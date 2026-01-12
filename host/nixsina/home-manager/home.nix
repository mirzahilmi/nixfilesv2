{
  pkgs,
  secrets,
  ...
}: {
  home = {
    username = secrets.user.primary.username;
    stateVersion = "23.11";
  };

  home.packages = with pkgs; [
    fastfetch
    gnumake
    neovim-git
  ];
}
