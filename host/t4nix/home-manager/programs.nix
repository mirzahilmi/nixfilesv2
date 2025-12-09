{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  spicetify-nix = inputs.spicetify-nix;
  spicetifyPkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [spicetify-nix.homeManagerModules.default];

  programs = {
    librewolf.enable = true;
    fastfetch.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
    bat.enable = true;
    lsd.enable = true;
    tealdeer.enable = true;
  };

  services = {
    ssh-agent.enable = true;
  };

  programs.spicetify = {
    enable = true;
    enabledCustomApps = with spicetifyPkgs.apps; [
      betterLibrary
      historyInSidebar
      localFiles
      lyricsPlus
      marketplace
      nameThatTune
    ];
    enabledExtensions = with spicetifyPkgs.extensions; [
      adblock
      beautifulLyrics
      hidePodcasts
      history
      shuffle
      volumePercentage
    ];
  };
  programs.ghostty = {
    enable = true;
    package = pkgs.unstable.ghostty;
  };
  programs.obs-studio = {
    enable = true;
    plugins = builtins.attrValues {
      inherit
        (pkgs.obs-studio-plugins)
        wlrobs
        input-overlay
        obs-backgroundremoval
        obs-pipewire-audio-capture
        ;
    };
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
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    defaultOptions = ["--layout=reverse --info=inline --height=90%"];
  };
  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = ["*.env" "*.env.json" "*.env.yaml" ".envrc"];
    settings = {
      user = {
        name = "mirzaganteng";
        email = "dev@mrz.my.id";
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

      gpg.format = "ssh";
      # thanks to:
      # https://www.reddit.com/r/git/comments/1coropv/comment/l3jeblh
      # https://www.reddit.com/r/git/comments/1coropv/comment/mdoiau0
      gpg.ssh.program = "${pkgs.ssh-sign-me-up}/bin/ssh-sign-me-up";
      commit.gpgSign = true;
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        pagers = [
          {
            pager = "delta --dark --paging=never";
            colorArg = "always";
          }
        ];
      };
    };
  };
  programs.delta = {
    enable = true;
    options = {
      line-numbers = true;
    };
  };
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."default".addKeysToAgent = "3h";
  };
  programs.tmux = {
    enable = true;
    secureSocket = true;
    extraConfig = builtins.readFile ./tmux.conf;
    plugins = builtins.attrValues {
      inherit (pkgs.tmuxPlugins) fingers;
    };
  };
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = false;
    history = {
      path = "${config.xdg.configHome}/zsh/history";
      extended = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };
    antidote = {
      enable = true;
      useFriendlyNames = true;
      plugins = [
        "mattmc3/ez-compinit"
        "zsh-users/zsh-completions kind:fpath path:src"
        "belak/zsh-utils path:editor"
        "zsh-users/zsh-autosuggestions kind:defer"
        "zdharma-continuum/fast-syntax-highlighting kind:defer"
        "Aloxaf/fzf-tab kind:defer"
      ];
    };
    shellAliases = {
      v = "nvim";
      mk = "make";
      lg = "lazygit";
      k9 = "k9s";
      k = "kubectl";
    };
    initContent = let
      zshConfigFirst = lib.mkBefore ''
        ## Profiling zsh startup
        [[ -n "''${ZSH_DEBUGRC+1}" ]] && zmodload zsh/zprof
        eval "$(${lib.getExe pkgs.oh-my-posh} init zsh --config ${config.xdg.configHome}/oh-my-posh/config.json)"
      '';
      zshConfig = ''
        if [ -x "$(command -v tmux)" ] && [ -n "''${WAYLAND_DISPLAY}" ] && [ -z "''${TMUX}" ]; then
          exec tmux new-session -A -s ''${USER} >/dev/null 2>&1
        fi

        fpath=($XDG_CACHE_HOME/zsh/completions $fpath)

        bindkey -e

        # ref: https://github.com/rothgar/mastering-zsh/blob/master/docs/config/history.md#configuration
        setopt INC_APPEND_HISTORY
        setopt HIST_FIND_NO_DUPS
        setopt HIST_SAVE_NO_DUPS
        setopt HIST_VERIFY
        setopt APPEND_HISTORY
        setopt HIST_NO_STORE

        zstyle ':completion:*' menu no

        [[ -n "''${ZSH_DEBUGRC+1}" ]] && zprof
      '';
    in
      lib.mkMerge [zshConfigFirst zshConfig];
  };
}
