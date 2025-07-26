{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkOption mkEnableOption;
  inherit (lib.types) str path;

  cfg = config.container.freshrss;
in
{
  options.container.freshrss = {
    enable = mkEnableOption "Enable the freshrss service";
    version = mkOption {
      type = str;
      default = "1.26.3-ls268";
      example = ''
        The most recent version can be found here:
        https://github.com/linuxserver/docker-freshrss/pkgs/container/freshrss
      '';
      description = "The docker image version for freshrss service";
    };
    port = mkOption {
      type = lib.types.port;
      default = 9123;
      description = "The port for freshrss service";
    };
    configDir = mkOption {
      type = path;
      description = ''
        Directory for configuration for freshrss service;
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };

    virtualisation.oci-containers.containers.freshrss = {
      autoStart = true;
      image = "lscr.io/linuxserver/freshrss:${cfg.version}";
      volumes = [
        "${cfg.configDir}:/config"
      ];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/Los_Angeles";
      };
      ports = [
        "${toString cfg.port}:80"
      ];
    };
  };
}
