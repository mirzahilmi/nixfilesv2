{
  inputs,
  final,
  prev,
}: {
  neovim = inputs.nvim.packages.${final.stdenv.hostPlatform.system}.default;
  neovim-static = inputs.nvim.packages.${final.stdenv.hostPlatform.system}.neovim-static;
  open-github = final.writeShellScriptBin "open-github" (builtins.readFile ./open-github.sh);
  release-please = final.callPackage ./release-please.nix {};
  ssh-sign-me-up = final.writeShellScriptBin "ssh-sign-me-up" (builtins.readFile ./ssh-sign-me-up.sh);
  xdg-open = final.writeShellScriptBin "xdg-open" (builtins.readFile ./xdg-open.sh);
}
