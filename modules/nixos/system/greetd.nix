{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf;

  session = "Hyprland";
in
{
  config = mkIf config.casa.profiles.graphical.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          user = "greeter";
          command = "${lib.getExe pkgs.tuigreet} --time --remember --cmd ${session}";
        };
      };
    };
  };
}
