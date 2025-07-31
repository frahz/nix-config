{ lib, config, ... }:
let
  inherit (lib) mkIf mapAttrs mkForce;
in
{
  config = mkIf config.casa.profiles.server.enable {
    # print the URL instead on servers
    environment.variables.BROWSER = "echo";

    # we don't need fonts on a server
    # since there are no fonts to be configured outside the console
    fonts = {
      packages = mkForce [ ];
      fontDir.enable = mkForce false;
      fontconfig.enable = mkForce false;
    };
  };
}
