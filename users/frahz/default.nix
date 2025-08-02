{
  inputs,
  self,
  lib,
  pkgs,
  homeProfile,
  ...
}:
{
  config = {
    home-manager = {
      useGlobalPkgs = true;
      extraSpecialArgs = { inherit inputs self; };
      users.frahz = {
        imports = homeProfile;
      };
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
        "networkmanager"
        "audio"
        "video"
        "lp"
        "docker"
        "immich"
      ];
      uid = 1000;
    });
  };
}
