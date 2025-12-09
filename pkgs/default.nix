{
  inputs,
  final,
  prev,
}: {
  ssh-sign-me-up = final.writeShellScriptBin "ssh-sign-me-up" (builtins.readFile ./ssh-sign-me-up.sh);
  neovim = inputs.nvim.packages.${final.stdenv.hostPlatform.system}.default;
}
