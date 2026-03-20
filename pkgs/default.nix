{
  inputs,
  final,
  prev,
}: {
  neovim = inputs.nvim.packages.${final.stdenv.hostPlatform.system}.default;
  ssh-sign-me-up = final.writeShellScriptBin "ssh-sign-me-up" (builtins.readFile ./ssh-sign-me-up.sh);
  open-github = final.writeShellScriptBin "open-github" (builtins.readFile ./open-github.sh);
  release-please = final.callPackage ./release-please.nix {};
}
