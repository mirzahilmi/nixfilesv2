{
  lib,
  stdenvNoCC,
  fetchurl,
}: let
  version = "0.9.3";
  sources = {
    x86_64-linux = {
      target = "linux-x86_64";
      hash = "sha256-GKjcZfHC+khYhDRDVt6hz9kRxvBs9G+njhk/QIf026c=";
    };
  };
  source = sources.${stdenvNoCC.hostPlatform.system} or (throw "herdr: unsupported system ${stdenvNoCC.hostPlatform.system}");
in
  stdenvNoCC.mkDerivation {
    pname = "herdr";
    inherit version;

    src = fetchurl {
      url = "https://github.com/herdrdev/herdr/releases/download/v${version}/herdr-${source.target}";
      inherit (source) hash;
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/herdr
      runHook postInstall
    '';

    meta = {
      homepage = "https://github.com/herdrdev/herdr";
      platforms = builtins.attrNames sources;
      mainProgram = "herdr";
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }
