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

  cfg = config.casa.services.nemui;
in
{
  imports = [
    inputs.paquetes.nixosModules.nemui
  ];

  options.casa.services.nemui = mkServiceOption "nemui" { };

  config = mkIf cfg.enable {
    services.nemui.enable = true;
  };
}
