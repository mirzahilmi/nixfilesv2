{outputs, ...}: {
  nix.settings = {
    experimental-features = toString ["nix-command" "flakes"];
    auto-optimise-store = true;
    warn-dirty = false;

    trusted-users = ["@wheel"];
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://install.determinate.systems"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
    ];
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };
}
