{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.casa.services.nemui;
in
{
  imports = [
    inputs.paquetes.nixosModules.nemui
  ];

  options.casa.services.nemui = {
    enable = mkEnableOption "nemui daemon";
  };

  config = mkIf cfg.enable {
    services.nemui.enable = true;
  };
}
