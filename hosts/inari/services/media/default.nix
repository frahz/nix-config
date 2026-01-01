{ config, ... }:
let
  cfg = config.casa.profiles.server;
in
{
  imports = [
    ./jellyfin.nix
    ./kavita.nix
    ./radarr.nix
    ./sonarr.nix
  ];

  users.groups.media = { };
  users.users.frahz.extraGroups = [ "media" ];

  systemd.tmpfiles.rules = [
    "d ${cfg.storage}/media 0770 - media - -"
    "d ${cfg.storage}/library 0770 - media - -"
  ];
}
