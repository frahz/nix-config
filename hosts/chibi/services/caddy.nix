{
  config,
  pkgs,
  inputs,
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
    glance = {
      port = 7576;
      domain = "";
    };
    linkwarden = {
      port = 3000;
      domain = "lw";
    };
    navidrome = {
      port = 4533;
      domain = "music";
    };
    sugoi = {
      port = 8080;
      domain = "sugoi";
    };
    forgejo = {
      port = 3200;
      domain = "git";
    };
    home-assistant = {
      port = 8123;
      domain = "home";
    };
  };

  inari = {
    ip = "100.68.202.4";
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
      port = 8989;
      domain = "sonarr";
    };
    scrutiny = {
      port = 9321;
      domain = "scrutiny";
    };
  };
in {
  services.caddy = {
    enable = true;
    email = "me@frahz.dev";
    package = inputs.nixpkgs-caddy.legacyPackages.${pkgs.system}.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/porkbun@v0.2.1"];
      hash = "sha256-ayd1WnjBjQOIXtiCkR/aWML2Nc4eRyuTugsjHXOU5uQ=";
    };
    globalConfig = ''
      acme_dns porkbun {
        api_key {env.PORKBUN_API_KEY}
        api_secret_key {env.PORKBUN_API_SECRET_KEY}
      }
    '';

    virtualHosts = {
      "${domain}" = {
        extraConfig = ''
          reverse_proxy http://${chibi.ip}:${toString chibi.glance.port}
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
      "${chibi.navidrome.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${chibi.ip}:${toString chibi.navidrome.port}
        '';
      };
      "${chibi.sugoi.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${chibi.ip}:${toString chibi.sugoi.port}
        '';
      };
      "${chibi.forgejo.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${chibi.ip}:${toString chibi.forgejo.port}
        '';
      };
      "${chibi.home-assistant.domain}.${domain}" = {
        extraConfig = ''
          reverse_proxy http://${chibi.ip}:${toString chibi.home-assistant.port}
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
