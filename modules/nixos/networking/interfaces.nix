{ lib, config, ... }:
let
  inherit (lib)
    mapAttrs
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.casa.networking;

  mkNetwork = _: name: {
    matchConfig.Name = name;
    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
    };
    linkConfig.RequiredForOnline = "routable";
    dhcpV4Config = {
      RouteMetric = 100;
      UseDNS = true;
      UseRoutes = true;
    };
  };
in
{
  options.casa.networking = {
    enable = mkEnableOption "systemd-networkd-backed host networking";

    interfaces = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Map of networkd unit names to interface names using Casa's default DHCP profile.";
    };
  };

  config = mkIf (cfg.enable || cfg.interfaces != { }) {

    systemd.network = {
      enable = true;
      networks = mapAttrs mkNetwork cfg.interfaces;
    };
  };
}
