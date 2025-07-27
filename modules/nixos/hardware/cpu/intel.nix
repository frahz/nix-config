{ lib, config, ... }:
let
  inherit (lib) mkDefault mkIf;

  cfg = config.casa.hardware;
in
{
  config = mkIf (cfg.cpu == "intel" || cfg.cpu == "vm-intel") {
    hardware.cpu.intel.updateMicrocode = mkDefault true;

    boot = {
      kernelModules = [ "kvm-intel" ];
    };
  };
}
