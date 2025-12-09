{
  outputs,
  config,
  ...
}: {
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  home.homeDirectory = "/home/${config.home.username}";
}
