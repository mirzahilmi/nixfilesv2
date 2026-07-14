{
  rustPlatform,
  fetchFromGitHub,
  ...
}: let
  version = "1.1.2";
in
  rustPlatform.buildRustPackage {
    pname = "ccometixline";
    inherit version;
    src = fetchFromGitHub {
      owner = "Haleclipse";
      repo = "CCometixLine";
      rev = "v${version}";
      hash = "sha256-W6+eGp8S6weOlS5WpmMR9JT4BVtyhettmtaFTStmyQk=";
    };
    cargoLock.lockFile = ./Cargo.ccometixline.lock;
    postInstall = ''
      mv $out/bin/ccometixline $out/bin/ccline
    '';
    meta.mainProgram = "ccline";
  }
