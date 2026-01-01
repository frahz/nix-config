{ config, ... }:
let
  cfg = config.casa.profiles.server;
in
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    dataDir = "${cfg.storage}/containers/jellyfin";
    user = "frahz";
    group = "media";
  };

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
  };
}
