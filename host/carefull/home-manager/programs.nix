{
  pkgs,
  config,
  lib,
  ...
}: {
  services = {ssh-agent.enable = true;};

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
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

  # programs.git = {
  #   enable = true;
  #   lfs.enable = true;
  #   ignores = ["*.env" "*.env.json" "*.env.yaml" ".envrc"];
  #   settings = {
  #     user = {
  #       name = "mirzaganteng";
  #       email = secrets.email.dev;
  #     };
  #     alias = {
  #       a = "add --all";
  #       graph = "log --decorate --oneline --graph";
  #     };
  #     branch.sort = "committerdate";
  #     column.ui = "auto";
  #     commit.verbose = true;
  #     init.defaultBranch = "master";
  #     merge.conflictStyle = "zdiff3";
  #     pull.rebase = true;
  #     push.autoSetupRemote = true;
  #     push.default = "simple";
  #     rerere.enabled = true;
  #     core.pager = "delta --navigate";
  #     interactive.diffFilter = "delta --color-only";
  #     delta.navigate = true;
  #     delta.line-numbers = true;
  #
  #     gpg.format = "ssh";
  #     # thanks to:
  #     # https://www.reddit.com/r/git/comments/1coropv/comment/l3jeblh
  #     # https://www.reddit.com/r/git/comments/1coropv/comment/mdoiau0
  #     gpg.ssh.program = "${pkgs.ssh-sign-me-up}/bin/ssh-sign-me-up";
  #     commit.gpgSign = true;
  #     user.signingkey = "~/.ssh/id_ed25519.pub";
  #   };
  # };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*".addKeysToAgent = "12h";
    };
  };

  programs.tmux = {
    enable = true;
    secureSocket = true;
    extraConfig = "source-file ${config.xdg.configHome}/tmux/extra.conf";
    plugins = builtins.attrValues {
      inherit (pkgs.unstable.tmuxPlugins) fingers;
    };
  };
  xdg.configFile."tmux/extra.conf".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/carefull/home-manager/tmux.conf";

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = false;
    antidote = {
      enable = true;
      useFriendlyNames = true;
      plugins = [
        "mattmc3/ez-compinit"
        "zsh-users/zsh-completions kind:fpath path:src"
        "zdharma-continuum/fast-syntax-highlighting kind:defer"
        "zsh-users/zsh-autosuggestions kind:defer"
        "zsh-users/zsh-history-substring-search kind:defer"
        "Aloxaf/fzf-tab kind:defer"
      ];
    };
    initContent = ''
      # start profiling
      [[ -n "''${ZSH_DEBUGRC+1}" ]] && zmodload zsh/zprof

      eval "$(${lib.getExe pkgs.oh-my-posh} init zsh --config ${config.xdg.configHome}/oh-my-posh/config.json)"

      # source fzf extension (Ctrl-R for example)
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh

      source ${config.xdg.configHome}/zsh/extra.zshrc
    '';
  };
  xdg.configFile."zsh/extra.zshrc".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixfilesv2/host/carefull/home-manager/.zshrc";
}
