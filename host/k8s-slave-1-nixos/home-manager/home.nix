{pkgs, ...}: {
  home = {
    username = "member";
    stateVersion = "25.11";
  };

  home.packages = with pkgs; [
    dig
    nmap
    unzip
    zip
    wget
    lz4
    fastfetch
    btop
  ];

  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      proc_sorting = "memory";
    };
  };

  programs.git = {
    enable = true;
    ignores = ["*.env" "*.env.json" "*.env.yaml" ".envrc"];
    settings = {
      user = {
        name = "mirzaganteng";
        email = "dev@mrz.my.id";
      };
      alias = {
        a = "add --all";
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
}
