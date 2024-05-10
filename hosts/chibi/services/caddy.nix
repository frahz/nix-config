{
  config,
  pkgs,
  ...
}: let
  domain = "iatze.cc";

  chibi = {
    ip = "100.87.38.99";
    adguardhome = {
      port = 8053;
      domain = "adguard";
    };
    excalidraw = {
      port = 3030;
      domain = "excalidraw";
    };
    freshrss = {
      port = 9123;
      domain = "freshrss";
    };
    homarr = {
      port = 7575;
      domain = "";
    };
    linkwarden = {
      port = 3000;
      domain = "lw";
    };
  };

  inari = {
    ip = "100.68.202.4";
    gitea = {
      port = 3000;
      domain = "git";
    };
    jellyfin = {
      port = 8096;
      domain = "jellyfin";
    };
    jellyseerr = {
      port = 5055;
      domain = "jellyseerr";
    };
    kavita = {
      port = 5000;
      domain = "kavita";
    };
    qbitorrent = {
      port = 8080;
      domain = "qb";
    };
    radarr = {
      port = 7878;
      domain = "radarr";
    };
    sonarr = {
      port = 8990;
      domain = "sonarr";
    };
    scrutiny = {
      port = 9321;
      domain = "scrutiny";
    };
  };
in {
  services.caddy = {
    enable = false;
    package = pkgs.caddy-with-porkbun;

    virtualHosts = {
      "*.${domain}" = {
        extraConfig = ''
          tls {
            dns porkbun {
              api_key {env.PORKBUN_API_KEY}
              api_secret_key {env.PORKBUN_API_PASSWORD}
            }
          }
        '';
      };
      "${domain}" = {
        extraConfig = ''
          tls {
            dns porkbun {
              api_key {env.PORKBUN_API_KEY}
              api_secret_key {env.PORKBUN_API_PASSWORD}
            }
          }
          reverse_proxy http://${chibi.ip}:${toString chibi.homarr.port}
        '';
      };
      "${chibi.linkwarden.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${chibi.ip}:${toString chibi.linkwarden.port}
        '';
      };
      "${chibi.freshrss.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${chibi.ip}:${toString chibi.freshrss.port}
        '';
      };
      "${chibi.excalidraw.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${chibi.ip}:${toString chibi.excalidraw.port}
        '';
      };
      "${chibi.adguardhome.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${chibi.ip}:${toString chibi.adguardhome.port}
        '';
      };
      "${inari.sonarr.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${inari.ip}:${toString inari.sonarr.port}
        '';
      };
      "${inari.radarr.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${inari.ip}:${toString inari.radarr.port}
        '';
      };
      "${inari.jellyfin.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${inari.ip}:${toString inari.jellyfin.port}
        '';
      };
      "${inari.qbitorrent.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${inari.ip}:${toString inari.qbitorrent.port}
        '';
      };
      "${inari.jellyseerr.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${inari.ip}:${toString inari.jellyseerr.port}
        '';
      };
      "${inari.kavita.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${inari.ip}:${toString inari.kavita.port}
        '';
      };
      "${inari.gitea.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${inari.ip}:${toString inari.gitea.port}
        '';
      };
      "${inari.scrutiny.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${inari.ip}:${toString inari.scrutiny.port}
        '';
      };
    };
  };

  sops.secrets.porkbun = {};
  systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.secrets.porkbun.path;

  networking.firewall = {
    allowedTCPPorts = [80 443];
    allowedUDPPorts = [80 443];
  };
}
