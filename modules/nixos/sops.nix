{ inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.default ];
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    # TODO: change to sshKey
    age.keyFile = "/home/frahz/.config/sops/age/keys.txt";
  };
}
