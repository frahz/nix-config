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
  options.casa.virtualisation = {
    enable = mkEnableOption "enable virtualisation support";
    enableOnBoot = mkEnableOption "enable docker on boot" // {
      default = true;
    };
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
