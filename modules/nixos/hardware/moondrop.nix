{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    optionals
    flatten
    ;

  paq = inputs.paquetes.packages.${pkgs.stdenv.hostPlatform.system};

  cfg = config.casa.hardware.moondrop;
in
{
  options.casa.hardware.moondrop = {
    enable = mkEnableOption "enables hardware acceleration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = flatten [
      paq.mdrop-cli
      (optionals config.casa.profiles.graphical.enable [
        paq.mdrop-gui
      ])
    ];

    services.udev.extraRules = ''
      # Moondrop DAC
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2fc6", MODE="0666"
      # These two devices cause sleep to fail the first time
      # USB XHC0 = keyboard
      # USB XHC1 = mouse
      ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1022" ATTR{device}=="0x161d" ATTR{power/wakeup}="disabled"
      ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1022" ATTR{device}=="0x161e" ATTR{power/wakeup}="disabled"
    '';

  };
}
