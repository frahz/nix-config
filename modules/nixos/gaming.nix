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
      gamemode = {
        enable = true;
        enableRenice = true;

        settings = {
          general = {
            softrealtime = "auto";
            renice = 15;
          };
        };
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      steam = {
        enable = true;
        extraCompatPackages = [
          pkgs.proton-ge-bin.steamcompattool
        ];
        gamescopeSession.enable = true;
      };
    };
  };
}
