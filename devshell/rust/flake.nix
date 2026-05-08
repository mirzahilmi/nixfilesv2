{
  description = "A Nix-flake-based Rust development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      inputs.nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [inputs.self.overlays.default];
          };
        });
  in {
    overlays.default = import inputs.rust-overlay;

    devShells = forEachSupportedSystem ({pkgs}: let
      rustToolchain = pkgs.rust-bin.stable.latest.default.override {
        # see https://rust-lang.github.io/rustup/concepts/components.html
        extensions = [
          "cargo"
          "clippy"
          "rust-analyzer"
          "rust-src"
          "rustc"
          "rustfmt"
        ];
      };
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          rustToolchain

          lldb
          openssl
          pkg-config

          cargo-edit
        ];
      };
    });
  };
}
