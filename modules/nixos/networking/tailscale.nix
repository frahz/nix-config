{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption mkEnableOption;
  inherit (lib.types) bool;

  cfg = config.casa.networking.tailscale;
in
{
  options.casa.networking.tailscale = {
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
    exitNode = {
      enable = mkEnableOption "Enable use as exit node";
    };
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      package = pkgs.tailscale;
      extraUpFlags = [ "--stateful-filtering=false" ];
      # TODO: change this to take actual username
      extraSetFlags = [ "--operator=frahz" ] ++ lib.optional cfg.exitNode.enable "--advertise-exit-node";
      useRoutingFeatures = mkIf cfg.isClient "client";
    };
  };
}
