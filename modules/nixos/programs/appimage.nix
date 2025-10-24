{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.casa.profiles.graphical.enable {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
