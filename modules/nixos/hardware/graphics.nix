{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  isx86Linux = pkgs.stdenv.hostPlatform.isLinux && pkgs.stdenv.hostPlatform.isx86;

  cfg = config.casa.hardware;
in
{
  options.casa.hardware.enableHardwareAcceleration = mkEnableOption "enables hardware acceleration";

  config = mkIf cfg.enableHardwareAcceleration {
    hardware.graphics = {
      enable = true;
      enable32Bit = isx86Linux;
    };
  };
}
