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

  cfg = config.casa.services.raulyrs;
in
{
  imports = [
    inputs.paquetes.nixosModules.raulyrs
  ];

  options.casa.services.raulyrs = mkServiceOption "raulyrs" { };

  config = mkIf cfg.enable {
    sops.secrets.raulyrs = { };

    services.raulyrs = {
      enable = true;
      environmentFile = config.sops.secrets.raulyrs.path;
    };
  };
}
