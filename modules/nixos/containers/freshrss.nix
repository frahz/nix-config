{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  inherit (self.lib) mkServiceOption;

  cfg = config.casa.containers.freshrss;
  rdomain = config.networking.domain;
in
{
  options.casa.containers.freshrss =
    mkServiceOption "freshrss" {
      port = 9123;
      domain = "freshrss.${rdomain}";
    }
    // {
      version = mkOption {
        type = types.str;
        default = "1.27.1-ls288";
        example = ''
          The most recent version can be found here:
          https://github.com/linuxserver/docker-freshrss/pkgs/container/freshrss
        '';
        description = "The docker image version for freshrss service";
      };
      configDir = mkOption {
        type = types.path;
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

    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
