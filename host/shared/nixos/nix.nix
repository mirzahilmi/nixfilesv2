{outputs, ...}: {
  nix.settings = {
    experimental-features = toString ["nix-command" "flakes"];
    auto-optimise-store = true;
    warn-dirty = false;

    trusted-users = ["@wheel"];
    # see https://nix-community.org/cache/
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };
}
