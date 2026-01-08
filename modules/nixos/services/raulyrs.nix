{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.casa.services.raulyrs;
in
{
  imports = [
    inputs.paquetes.nixosModules.raulyrs
  ];

  options.casa.services.raulyrs = {
    enable = mkEnableOption "raulyrs discord bot";
  };

  config = mkIf cfg.enable {
    sops.secrets.raulyrs = { };

    services.raulyrs = {
      enable = true;
      environmentFile = config.sops.secrets.raulyrs.path;
    };
  };
}
