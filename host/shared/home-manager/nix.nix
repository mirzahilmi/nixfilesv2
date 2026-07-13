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
      permittedInsecurePackages = [
        "electron-39.8.10"
      ];
    };
  };
  home.homeDirectory = "/home/${config.home.username}";
}
