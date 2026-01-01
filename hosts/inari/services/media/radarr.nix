{ config, ... }:
let
  cfg = config.casa.profiles.server;
in
{
  services.radarr = {
    enable = true;
    openFirewall = true;
    dataDir = "${cfg.storage}/containers/radarr/config";
    user = "frahz";
    group = "media";
  };
}
