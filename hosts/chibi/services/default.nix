{
  lib,
  config,
  ...
}:
let
  cfg = config.homelab;
in
{
  imports = [
    ./adguardhome.nix
    ./caddy.nix
    ./forgejo.nix
    ./glance.nix
    ./hass
    ./immich.nix
    ./navidrome.nix
    ./sugoi.nix
  ];

  options.homelab = {
    domain = lib.mkOption {
      default = "iatze.cc";
      type = lib.types.str;
      description = ''
        Base domain for homelab services.
      '';
    };
  };
}
