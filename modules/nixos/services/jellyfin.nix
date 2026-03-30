{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption;
  inherit (config.casa.profiles.server) storage;

  cfg = config.casa.services.jellyfin;

  rdomain = config.networking.domain;
in
{
  options.casa.services.jellyfin = mkServiceOption "jellyfin" {
    port = 8096;
    domain = "jellyfin.${rdomain}";
  };

  config = mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
      dataDir = "${storage}/containers/jellyfin";
      user = "frahz";
      group = "media";
    };

    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
