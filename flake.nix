{
  description = "github.com/mirzahilmi/nixfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-system.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-25_05.url = "github:nixos/nixpkgs/nixos-25.05";

    hardware.url = "github:nixos/nixos-hardware";
    nvim.url = "github:mirzahilmi/nvim";
    nixsecrets.url = "git+ssh://git@ssh.github.com:443/mirzahilmi/nixsecrets.git?ref=master&shallow=1";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mysecrets = {
      url = "git+ssh://git@ssh.github.com:443/mirzahilmi/sops.git?ref=master&shallow=1";
      flake = false;
    };
    nixos-06cb-009a-fingerprint-sensor = {
      url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor?ref=25.05";
      inputs.nixpkgs.follows = "nixpkgs-25_05";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    x86 = "x86_64-linux";
    overlays = import ./overlay.nix {inherit inputs;};
    libx = import ./lib.nix {
      lib = nixpkgs.lib // home-manager.lib;
    };
    secrets = inputs.nixsecrets.secrets;

    mkSystem = {
      hostname,
      system,
      modules ? [],
      args ? {},
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          libx.listNixfiles ./host/${hostname}/nixos
          ++ libx.listNixfiles ./host/shared/nixos
          ++ modules;
        specialArgs = args // {inherit inputs outputs libx;};
      };

    mkHome = {
      username,
      hostname,
      system,
      modules ? [],
      args ? {},
    }:
      home-manager.lib.homeManagerConfiguration {
        modules =
          libx.listNixfiles ./host/${hostname}/home-manager
          ++ libx.listNixfiles ./host/shared/home-manager
          ++ modules;
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs =
          args
          // {
            inherit inputs outputs libx;
            current = {inherit username hostname;};
            osConfig = outputs.nixosConfigurations.${hostname}.config;
          };
      };
  in {
    inherit overlays;

    nixosConfigurations = {
      t4nix = mkSystem {
        hostname = "t4nix";
        system = x86;
        modules = [
          inputs.hardware.nixosModules.lenovo-thinkpad-t480s
          inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules."06cb-009a-fingerprint-sensor"
        ];
        args = {inherit secrets;};
      };
      k8s-slave-1-nixos = mkSystem {
        system = x86;
        hostname = "k8s-slave-1-nixos";
      };
      anuc = mkSystem {
        system = x86;
        hostname = "anuc";
        args = {inherit secrets;};
      };
    };

    homeConfigurations = {
      "t4nix@t4nix" = mkHome {
        system = x86;
        username = secrets.user.primary.username;
        hostname = "t4nix";
        modules = [
          inputs.spicetify-nix.homeManagerModules.default
        ];
        args = {inherit secrets;};
      };
      "member@k8s-slave-1-nixos" = mkHome {
        system = x86;
        username = "member";
        hostname = "k8s-slave-1-nixos";
      };
      "anuc@anuc" = mkHome {
        system = x86;
        username = secrets.user.secondary.username;
        hostname = "anuc";
        args = {inherit secrets;};
      };
    };
  };
}
