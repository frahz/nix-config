{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.casa.profiles = {
    graphical.enable = mkEnableOption "Graphical Interface";
    server.enable = mkEnableOption "Server";
  };
}
