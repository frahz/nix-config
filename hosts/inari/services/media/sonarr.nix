{ config, ... }:
let
  cfg = config.casa.profiles.server;
in
{
  services.sonarr = {
    enable = true;
    openFirewall = true;
    dataDir = "${cfg.storage}/containers/sonarr/config";
    user = "frahz";
    group = "media";
  };
}
