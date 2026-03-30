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

  cfg = config.casa.services.sonarr;

  rdomain = config.networking.domain;
in
{
  options.casa.services.sonarr = mkServiceOption "sonarr" {
    port = 8989;
    domain = "sonarr.${rdomain}";
  };

  config = mkIf cfg.enable {
    services.sonarr = {
      enable = true;
      openFirewall = true;
      dataDir = "${storage}/containers/sonarr/config";
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
