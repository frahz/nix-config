{
  lib,
  pkgs,
  ...
}:
let
  username = "frahz";
in
{
  users.users.${username} = {
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
    shell = pkgs.zsh;
    description = "frahz";
    uid = 1000;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6ZRCt+Fhx6tVAih57zCNgv8E/THbv8eAl6hXEnmS5/"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILKyBGpzn7xsMi9oqsOUHsWrTiTsH47nj3eW1cFK/JQ+ me@frahz.dev"
    ];
  };
}
