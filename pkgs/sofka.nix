{
  lib,
  stdenvNoCC,
  fetchurl,
}: let
  version = "0.29.6";
  sources = {
    x86_64-linux = {
      target = "x86_64-unknown-linux-musl";
      hash = "sha256-sd5y2ZdhIqx3jFkDjqY8SBngVQkmIJ3j1+N1/VauWI0=";
    };
    aarch64-linux = {
      target = "aarch64-unknown-linux-musl";
      hash = "sha256-rs+AA+3lc5bdH9wx11cLHzIxwacGFvQz2MiFk9PgIjM=";
    };
  };
  source = sources.${stdenvNoCC.hostPlatform.system} or (throw "sofka: unsupported system ${stdenvNoCC.hostPlatform.system}");
in
  stdenvNoCC.mkDerivation {
    pname = "sofka";
    inherit version;

    src = fetchurl {
      url = "https://github.com/nklmilojevic/sofka/releases/download/v${version}/sofka-v${version}-${source.target}.tar.gz";
      inherit (source) hash;
    };

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      install -Dm755 sofka $out/bin/sofka
      runHook postInstall
    '';

    meta = {
      homepage = "https://github.com/nklmilojevic/sofka";
      license = with lib.licenses; [mit asl20];
      platforms = builtins.attrNames sources;
      mainProgram = "sofka";
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }
