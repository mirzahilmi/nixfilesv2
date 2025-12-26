{outputs, ...}: {
  nix = {
    settings = {
      experimental-features = toString ["nix-command" "flakes"];
    };
  };
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };
}
