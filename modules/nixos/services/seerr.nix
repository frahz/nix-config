{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption;

  cfg = config.casa.services.seerr;
  rdomain = config.networking.domain;
in
{
  options.casa.services.seerr = mkServiceOption "seerr" {
    port = 5055;
    domain = "seerr.${rdomain}";
  };

  config = mkIf cfg.enable {
    services.seerr = {
      enable = true;
      openFirewall = true;
      inherit (cfg) port;
    };

    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
