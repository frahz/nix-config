{ lib, config, ... }:
let
  inherit (lib) mkDefault mkIf;

  cfg = config.casa.hardware;
in
{
  config = mkIf (cfg.cpu == "amd" || cfg.cpu == "vm-amd") {
    hardware.cpu.amd.updateMicrocode = mkDefault true;

    boot = {
      initrd.availableKernelModules = [ "thunderbolt" ];
      kernelModules = [
        "kvm-amd"
        "amd-pstate"
      ];
    };
  };
}
