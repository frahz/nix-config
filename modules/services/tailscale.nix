{ pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    package = pkgs.tailscale;
    extraUpFlags = [ "--stateful-filtering=false" ];
    extraSetFlags = [ "--operator=frahz" ];
  };
}
