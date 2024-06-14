{config, ...}: let
  cfg = config.media;
in {
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
