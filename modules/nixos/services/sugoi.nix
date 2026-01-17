{
  inputs,
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption;

  cfg = config.casa.services.sugoi;

  rdomain = config.networking.domain;
in
{
  imports = [
    inputs.paquetes.nixosModules.sugoi
  ];

  options.casa.services.sugoi = mkServiceOption "sugoi" {
    domain = "sugoi.${rdomain}";
  };

  config = mkIf cfg.enable {
    services = {
      sugoi.enable = true;

      caddy.virtualHosts.${cfg.domain} = {
        extraConfig = ''
          reverse_proxy http://localhost:${toString config.services.sugoi.port}
        '';
      };
    };
  };
}
