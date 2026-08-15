{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.lists) singleton;
in
{
  config = mkIf config.casa.profiles.graphical.enable {
    hjem.users.frahz.packages = builtins.attrValues {
      inherit (pkgs) legendary-gl winetricks;

      prismlauncher = pkgs.prismlauncher.override {
        jdks = singleton pkgs.jdk17;
      };
    };

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
        extraCompatPackages = singleton pkgs.proton-ge-bin.steamcompattool;
        gamescopeSession.enable = true;
      };
    };
  };
}
