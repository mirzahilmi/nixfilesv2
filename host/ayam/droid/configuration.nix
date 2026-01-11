{pkgs, ...}: {
  terminal.font = "${pkgs.systemPackages.nerd-fonts.iosevka-term}/share/fonts/truetype/NerdFonts/IosevkaTerm/IosevkaTermNerdFont-Regular.ttf";

  environment.packages = with pkgs; [
    btop
    git
    gnutar
    hostname
    k9s
    kubectl
    neovim-git
    nmap
    openssh
    rsync
    zstd
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";
  system.stateVersion = "24.05";
}
