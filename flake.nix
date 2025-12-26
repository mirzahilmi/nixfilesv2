{
  description = "github.com/mirzahilmi/nixfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-system.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";
    nvim.url = "/home/mirza/.config/nvim";
    nvim-git.url = "github:mirzahilmi/nvim";

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

    mkSystem = {
      hostname,
      system,
      modules ? [],
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          libx.listNixfiles ./host/${hostname}/nixos
          ++ libx.listNixfiles ./host/shared/nixos;
        specialArgs = {inherit inputs outputs libx;};
      };

    mkHome = {
      username,
      hostname,
      system,
    }:
      home-manager.lib.homeManagerConfiguration {
        modules =
          libx.listNixfiles ./host/${hostname}/home-manager
          ++ libx.listNixfiles ./host/shared/home-manager;
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
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
        modules = [inputs.hardware.nixosModules.lenovo-thinkpad-t480s];
      };
      k8s-slave-1-nixos = mkSystem {
        hostname = "k8s-slave-1-nixos";
        system = x86;
      };
      anuc = mkSystem {
        hostname = "anuc";
        system = x86;
      };
    };

    homeConfigurations = let
    in {
      "mirza@t4nix" = mkHome {
        system = x86;
        username = "mirza";
        hostname = "t4nix";
      };
      "member@k8s-slave-1-nixos" = mkHome {
        system = x86;
        username = "member";
        hostname = "k8s-slave-1-nixos";
      };
      "hilmi@anuc" = mkHome {
        system = x86;
        username = "hilmi";
        hostname = "anuc";
      };
    };
  };
}
