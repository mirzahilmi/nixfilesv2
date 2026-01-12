{
  pkgs,
  config,
  secrets,
  ...
}: {
  programs = {
    lsd.enable = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      proc_sorting = "memory";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = false;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableNushellIntegration = false;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
    stdlib = ''
      : "${config.xdg.cacheHome}"
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          local hash path
          echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="$(sha1sum - <<< "$PWD" | head -c40)"
              path="''${PWD//[^a-zA-Z0-9]/-}"
              echo "${config.xdg.cacheHome}/direnv/layouts/''${hash}''${path}"
          )}"
      }
    '';
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = ["*.env" "*.env.json" "*.env.yaml" ".envrc"];
    settings = {
      user = {
        name = "mirzaganteng";
        email = secrets.email.dev;
      };
      alias = {
        a = "add --all";
        graph = "log --decorate --oneline --graph";
      };
      branch.sort = "committerdate";
      column.ui = "auto";
      commit.verbose = true;
      init.defaultBranch = "master";
      merge.conflictStyle = "zdiff3";
      pull.rebase = true;
      push.autoSetupRemote = true;
      push.default = "simple";
      rerere.enabled = true;
    };
  };

  programs.tmux = {
    enable = true;
    secureSocket = true;
  };
}
