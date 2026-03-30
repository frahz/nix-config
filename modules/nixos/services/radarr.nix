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

  cfg = config.casa.services.radarr;

  rdomain = config.networking.domain;
in
{
  options.casa.services.radarr = mkServiceOption "radarr" {
    port = 7878;
    domain = "radarr.${rdomain}";
  };

  config = mkIf cfg.enable {
    services.radarr = {
      enable = true;
      openFirewall = true;
      dataDir = "${storage}/containers/radarr/config";
      user = "frahz";
      group = "media";
      settings.server = { inherit (cfg) port; };
    };
    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
