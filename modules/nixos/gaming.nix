{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.casa.profiles.graphical.enable {
    programs = {
      gamemode.enable = true;
      steam = {
        enable = true;
        extraCompatPackages = [
          pkgs.proton-ge-bin.steamcompattool
        ];
      };
    };
  };
}
