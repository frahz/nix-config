{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption;

  cfg = config.casa.services.scrutiny;
  rdomain = config.networking.domain;
in
{
  options.casa.services.scrutiny = mkServiceOption "scrutiny" {
    port = 9321;
    domain = "scrutiny.${rdomain}";
  };

  config = mkIf cfg.enable {
    services.scrutiny = {
      enable = true;
      settings.web = {
        listen.port = cfg.port;
      };
      collector.enable = true;
    };
    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
