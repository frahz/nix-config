{
  lib,
  pkgs,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings = rec {
      tuigreet_session =
        let
          session = "Hyprland";
          tuigreet = "${lib.getExe pkgs.greetd.tuigreet}";
        in
        {
          command = "${tuigreet} --time --remember --cmd ${session}";
          user = "greeter";
        };
      default_session = tuigreet_session;
    };
  };
}
