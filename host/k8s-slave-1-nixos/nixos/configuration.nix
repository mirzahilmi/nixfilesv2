{
  pkgs,
  config,
  ...
}: {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "k8s-slave-1-nixos";
  networking.networkmanager.enable = true;
  system.stateVersion = "25.11"; # Did you read the comment?

  time.timeZone = "Asia/Jakarta";

  environment.systemPackages = with pkgs; [
    git
    vim
    ipvsadm
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
    nodeName = "k8s-slave-1-nixos";
    tokenFile = config.sops.secrets."k3s/token".path;
    configPath = config.sops.templates."k3s-config.yaml".path;

    extraKubeProxyConfig = {
      clientConnection = {
        kubeconfig = "/var/lib/rancher/k3s/agent/kubeproxy.kubeconfig";
      };
      mode = "ipvs";
      ipvs.scheduler = "lc";
    };
  };

  programs.tcpdump.enable = true;
  networking.firewall.enable = false;
}
