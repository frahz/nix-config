{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkOption mkEnableOption;
  inherit (lib.types)
    str
    path
    nullOr
    ;

  cfg = config.container.torrent;
in
{
  options.container.torrent = {
    enable = mkEnableOption "enables torrenting(qbittorrent/gluetun) containers";
    qbittorrent = {
      version = mkOption {
        type = str;
        default = "5.0.3-r0-ls375";
        example = ''
          The most recent version can be found here:
          https://github.com/linuxserver/docker-qbittorrent/pkgs/container/qbittorrent
        '';
        description = "The docker image version for qbittorrent service";
      };
      torrentPort = mkOption {
        type = lib.types.port;
        default = 26570;
        description = "The torrenting port for qbittorrent service";
      };
      webUiPort = mkOption {
        type = lib.types.port;
        default = 8080;
        description = "The web UI port for qbittorrent service";
      };
      configDir = mkOption {
        type = path;
        description = ''
          Directory for configuration for qbittorrent service;
        '';
      };
      torrentDir = mkOption {
        type = path;
        description = ''
          Directory for torrents for qbittorrent service;
        '';
      };
    };
    gluetun = {
      version = mkOption {
        type = str;
        default = "v3.40.0";
        example = ''
          The most recent version can be found here:
          https://github.com/qdm12/gluetun/releases
        '';
        description = "The docker image version for gluetun service";
      };
      port = mkOption {
        type = lib.types.port;
        default = 8888;
        description = "The torrenting port for gluetun service";
      };
      configDir = mkOption {
        type = path;
        description = ''
          Directory for configuration for gluetun service
        '';
      };
      serversFile = mkOption {
        type = path;
        description = ''
          custom VPN servers list:
          https://github.com/qdm12/gluetun-wiki/blob/main/setup/servers.md#update-the-vpn-servers-list
        '';
      };
      environmentFile = mkOption {
        type = nullOr path;
        default = null;
        description = "The environment file to use for gluetun";
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [
        cfg.gluetun.port
        cfg.qbittorrent.torrentPort
        cfg.qbittorrent.webUiPort
      ];
      allowedUDPPorts = [
        cfg.qbittorrent.torrentPort
        cfg.qbittorrent.webUiPort
      ];
    };

    virtualisation.oci-containers.containers.gluetun = {
      autoStart = true;
      image = "qmcgaw/gluetun:${cfg.gluetun.version}";
      volumes = [
        "${cfg.gluetun.configDir}:/config"
        "${cfg.gluetun.serversFile}:/gluetun/servers.json"
      ];
      ports = [
        "${toString cfg.gluetun.port}:${toString cfg.gluetun.port}/tcp"
        "${toString cfg.qbittorrent.webUiPort}:${toString cfg.qbittorrent.webUiPort}"
        "${toString cfg.qbittorrent.torrentPort}:${toString cfg.qbittorrent.torrentPort}"
      ];
      environmentFiles = [ cfg.gluetun.environmentFile ];
      environment = {
        TZ = "America/Los_Angeles";
        VPN_SERVICE_PROVIDER = "airvpn";
        VPN_TYPE = "wireguard";
        HEALTH_VPN_DURATION_INITIAL = "120s";
      };
      capabilities = {
        NET_ADMIN = true;
      };
      devices = [ "/dev/net/tun" ];
    };

    virtualisation.oci-containers.containers.qbittorrent = {
      autoStart = true;
      image = "lscr.io/linuxserver/qbittorrent:${cfg.qbittorrent.version}";
      volumes = [
        "${cfg.qbittorrent.configDir}:/config"
        "${cfg.qbittorrent.torrentDir}:/torrents"
      ];
      environment = {
        TZ = "America/Los_Angeles";
        PUID = "1000";
        PGID = "992"; # media
        WEB_UI_PORT = toString cfg.qbittorrent.webUiPort;
      };
      dependsOn = [ "gluetun" ];
      networks = [ "container:gluetun" ];
    };
  };
}
