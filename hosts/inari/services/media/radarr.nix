{config, ...}: let
  cfg = config.media;
in {
  services.radarr = {
    enable = true;
    openFirewall = true;
    dataDir = "${cfg.storage}/containers/radarr/config";
    group = "media";
  };
}
