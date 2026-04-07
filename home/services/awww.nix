{
  pkgs,
  osConfig,
  ...
}:
let
  cfg = osConfig.casa;
in
{
  services.awww = {
    enable = cfg.profiles.graphical.enable && pkgs.stdenv.hostPlatform.isLinux;
  };
}
