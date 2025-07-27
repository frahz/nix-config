{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption mkEnableOption;
  inherit (lib.types) bool;

  cfg = config.casa.services.tailscale;
in
{
  options.casa.services.tailscale = {
    enable = mkEnableOption "Enable tailscale services" // {
      default = true;
    };
    isClient = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether the target host should utilize Tailscale client features
      '';
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.tailscale ];

    services.tailscale = {
      enable = true;
      package = pkgs.tailscale;
      extraUpFlags = [ "--stateful-filtering=false" ];
      # TODO: change this to take actual username
      extraSetFlags = [ "--operator=frahz" ];
      useRoutingFeatures = mkIf cfg.isClient "client";
    };
  };
}
