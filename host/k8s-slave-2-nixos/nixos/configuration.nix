{
  outputs,
  pkgs,
lib,
  ...
}: {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "k8s-slave-2-nixos";
  networking.networkmanager.enable = true;
  system.stateVersion = "25.11"; # Did you read the comment?

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  nix.settings = {
    experimental-features = toString ["nix-command" "flakes"];
  };

  time.timeZone = "Asia/Jakarta";

  environment.systemPackages = with pkgs; [
    git
    vim
  ];
  services.openssh.enable = true;

  users.users."member" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = [pkgs.systemPackages.home-manager];
  };

  security.sudo.extraRules = [
    {
      users = ["member"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  networking.nftables.enable = true;

  services.k3s = {
    enable = true;
    role = "agent";
    nodeName = "k8s-slave-2-nixos";
    tokenFile = "/tmp/k3stoken";
    serverAddr = "http://example.com";

    extraKubeProxyConfig = {
  clientConnection = {
    kubeconfig = "/var/lib/rancher/k3s/agent/kubeproxy.kubeconfig";
  };
      mode = "nftables";
    };
  };

programs.tcpdump.enable = true;
networking.firewall.enable=false;
}
