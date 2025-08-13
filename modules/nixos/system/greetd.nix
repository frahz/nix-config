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
    services.greetd = {
      enable = true;
      settings = rec {
        tuigreet_session =
          let
            session = "Hyprland";
            tuigreet = "${lib.getExe pkgs.tuigreet}";
          in
          {
            command = "${tuigreet} --time --remember --cmd ${session}";
            user = "greeter";
          };
        default_session = tuigreet_session;
      };
    };
  };
}
