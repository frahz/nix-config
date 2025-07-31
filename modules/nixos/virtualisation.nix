{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.casa.virtualisation;
in
{
  # TODO: add more granularity later
  options.casa.virtualisation = {
    enable = mkEnableOption "nemui daemon";
  };

  config = mkIf cfg.enable {

    virtualisation = {
      oci-containers.backend = "docker";
      docker = {
        enable = true;
        autoPrune.enable = true;
      };
    };

    environment.systemPackages = [
      pkgs.lazydocker
    ];
  };

}
