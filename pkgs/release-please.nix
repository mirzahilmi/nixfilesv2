{
  buildNpmPackage,
  fetchFromGitHub,
  ...
}: let
  version = "17.2.0";
in
  buildNpmPackage {
    pname = "release-please";
    inherit version;
    src = fetchFromGitHub {
      owner = "googleapis";
      repo = "release-please";
      rev = "v${version}";
      hash = "sha256-ptBhewOe+VvzpygqquN7s2yuGruumuRyGD0obNP2uPg=";
    };
    npmDepsHash = "sha256-cePDO5cwC6Z50wDzeEYu0C/X3Hd/CdLduqVtxCBzom8=";
    dontNpmBuild = true;
  }
