{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.options) mkOption literalExpression;
  inherit (lib.types) raw listOf package;

  cfg = config.casa.system.boot;
in
{
  options.casa.system.boot = {
    kernel = mkOption {
      type = raw;
      default = pkgs.linuxPackages_latest;
      defaultText = "pkgs.linuxPackages_latest";
      description = "The kernel to use for the system.";
    };
    extraModulePackages = mkOption {
      type = listOf package;
      default = [ ];
      example = literalExpression ''with config.boot.kernelPackages; [acpi_call]'';
      description = "Extra kernel modules to be loaded.";
    };
  };

  config = {
    boot = {
      inherit (cfg) extraModulePackages;

      kernelPackages = cfg.kernel;

      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
          editor = false;
        };
        efi.canTouchEfiVariables = true;
        timeout = 5;
      };

      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "ahci"
          "nvme"
          "usb_storage"
          "usbhid"
          "sd_mod"
        ];
      };
    };
  };

}
