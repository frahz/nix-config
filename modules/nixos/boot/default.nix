{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkForce
    mkIf
    mkMerge
    ;
  inherit (lib.lists) optionals;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum raw;

  cfg = config.casa.system.boot;
in
{
  options.casa.system.boot = {
    loader = mkOption {
      type = enum [
        "none"
        "systemd-boot"
      ];
      default = "systemd-boot";
      description = "The bootloader that should be used for the device.";
    };
    kernel = mkOption {
      type = raw;
      default = pkgs.linuxPackages_latest;
      defaultText = "pkgs.linuxPackages_latest";
      description = "The kernel to use for the system.";
    };
    silentBoot = mkEnableOption ''
      almost entirely silent boot process through `quiet` kernel parameter
    '';
  };

  config = mkMerge [
    (mkIf (cfg.loader == "none") {
      boot.loader = {
        grub.enable = mkForce false;
        systemd-boot.enable = mkForce false;
      };
    })

    (mkIf (cfg.loader == "systemd-boot") {
      boot.loader.systemd-boot = {
        enable = true;
        configurationLimit = 10;
        editor = false;
      };

    })

    ({
      boot = {
        kernelPackages = cfg.kernel;

        loader = {
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

        kernelParams = optionals cfg.silentBoot [
          # tell the kernel to not be verbose, the voices are too loud
          "quiet"

          # kernel log message level
          "loglevel=3" # 1: system is unusable | 3: error condition | 7: very verbose

          # udev log message level
          "udev.log_level=3"

          # lower the udev log level to show only errors or worse
          "rd.udev.log_level=3"

          # disable systemd status messages
          # rd prefix means systemd-udev will be used instead of initrd
          "systemd.show_status=auto"
          "rd.systemd.show_status=auto"
        ];
      };
    })
  ];

}
