{ config, ... }:
let
  rdomain = config.casa.profiles.server.domain;
in
{
  services.sugoi.enable = true;

  services.caddy.virtualHosts."sugoi.${rdomain}" = {
    extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.sugoi.port}
    '';
  };
}
