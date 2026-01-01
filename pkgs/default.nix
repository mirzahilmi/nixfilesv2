{
  inputs,
  final,
  prev,
}: {
  neovim = inputs.nvim.packages.${final.stdenv.hostPlatform.system}.default;
  neovim-git = inputs.nvim.packages.${final.stdenv.hostPlatform.system}.precompiled;
  ssh-sign-me-up = final.writeShellScriptBin "ssh-sign-me-up" (builtins.readFile ./ssh-sign-me-up.sh);
  open-github = final.writeShellScriptBin "open-github" (builtins.readFile ./open-github.sh);
}
