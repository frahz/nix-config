{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf concatStringsSep;

  sessionData = config.services.displayManager.sessionData.desktops;
  sessionPath = concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];
in
{
  config = mkIf config.casa.profiles.graphical.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          user = "greeter";
          command = "${lib.getExe pkgs.tuigreet} --time --remember --sessions '${sessionPath}'";
        };
      };
    };
  };
}
