{ config, ... }:
let
  cfg = config.media;
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
