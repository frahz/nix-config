{
  pkgs,
  osConfig,
  ...
}:
let
  cfg = osConfig.casa;
in
{
  services.swww = {
    enable = cfg.profiles.graphical.enable && pkgs.stdenv.hostPlatform.isLinux;
  };
}
