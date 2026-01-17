{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkOption types;

  cfg = config.casa.profiles;
in
{
  options.casa.profiles = {
    graphical.enable = mkEnableOption "Graphical Interface";
    server = {
      enable = mkEnableOption "Server";
      storage = mkOption {
        type = types.str;
        default = null;
        description = "The storage location for data in this server";
      };
      domain = mkOption {
        type = types.str;
        default = "iatze.cc";
        description = "Base domain for homelab services.";
      };
    };
    development.enable = mkEnableOption "Development Tools";
  };

  config = {
    assertions = [
      {
        assertion = cfg.server.enable -> cfg.server.storage != null;
        message = "Server profile is enabled but storage option is not set. Please set config.casa.profiles.server.storage";
      }
    ];

    networking = { inherit (cfg.server) domain; };
  };
}
