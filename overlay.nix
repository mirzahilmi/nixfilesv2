{inputs, ...}: {
  customNixpkgs = final: prev: let
    pull = nixpkgs:
      import nixpkgs {
        inherit (prev) system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
  in rec {
    unstable = pull inputs.nixpkgs-unstable;
    systemPackages = pull inputs.nixpkgs-system;
    kdePackages = systemPackages.kdePackages;
  };

extra = final: prev: import ./pkgs {inherit inputs final prev;};
}
