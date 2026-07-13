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

  lazygit = prev.lazygit.overrideAttrs (old: rec {
    version = "0.63.0";
    src = prev.fetchFromGitHub {
      owner = "jesseduffield";
      repo = "lazygit";
      tag = "v${version}";
      hash = "sha256-WDGYS2W0FCIDoayafzUjcwTAW+v2jxfJo54kaM6ymCE=";
    };
    ldflags = [
      "-X main.version=${version}"
      "-X main.buildSource=nix"
    ];
  });
}
