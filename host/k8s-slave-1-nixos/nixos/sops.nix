{
  inputs,
  config,
  ...
}: let
  secretspath = "${builtins.toString inputs.mysecrets}/k3s.yaml";
in {
  imports = [inputs.sops-nix.nixosModules.sops];
  sops = {
    defaultSopsFile = secretspath;
    validateSopsFiles = false;
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      generateKey = true;
    };
    secrets = {
      "k3s/token" = {
        owner = config.users.users."member".name;
        group = "users";
      };
      "k3s/serverAddr" = {
        owner = config.users.users."member".name;
        group = "users";
      };
    };
    templates."k3s-config.yaml" = {
      content = ''
        server: "${config.sops.placeholder."k3s/serverAddr"}"
      '';
      owner = config.users.users."member".name;
      group = "users";
    };
  };
}
