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
    enable = mkEnableOption "enable virtualisation support";
    enableOnBoot = mkEnableOption "enable dockere on boot";
  };

  config = mkIf cfg.enable {

    virtualisation = {
      oci-containers.backend = "docker";
      docker = {
        inherit (cfg) enableOnBoot;
        enable = true;
        autoPrune.enable = true;
      };
    };

    environment.systemPackages = [
      pkgs.lazydocker
    ];
  };

}
