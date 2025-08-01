{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  isx86Linux = pkgs.stdenv.hostPlatform.isLinux && pkgs.stdenv.hostPlatform.isx86;
in
{

  config = mkIf config.casa.profiles.graphical.enable {
    services = {
      pipewire = {
        enable = true;

        audio.enable = true;
        pulse.enable = true;

        alsa = {
          enable = true;
          support32Bit = isx86Linux;
        };
      };

      pulseaudio.enable = false;
    };

    security.rtkit.enable = true;
  };
}
