{
  inputs,
  self,
  lib,
  pkgs,
  config,
  ...
}:
let
  ifExists = config: groups: lib.filter (group: lib.hasAttr group config.users.groups) groups;
in
{
  config = {
    home-manager = {
      useGlobalPkgs = true;
      extraSpecialArgs = { inherit inputs self; };
      users.frahz = ../../home;
    };

    users.users.frahz = {
      home = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/frahz" else "/home/frahz";
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6ZRCt+Fhx6tVAih57zCNgv8E/THbv8eAl6hXEnmS5/"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILKyBGpzn7xsMi9oqsOUHsWrTiTsH47nj3eW1cFK/JQ+ me@frahz.dev"
      ];
    }
    // (lib.optionalAttrs (!pkgs.stdenv.hostPlatform.isDarwin) {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "nix"
      ]
      ++ ifExists config [
        "network"
        "networkmanager"
        "audio"
        "video"
        "lp"
        "docker"
        "immich"
        "media"
      ];
      uid = 1000;
    });
  };
}
