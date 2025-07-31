{
  config,
  pkgs,
  ...
}:
let
  inherit (config.homelab) domain;

  chibi = {
    ip = "100.87.38.99";
    freshrss = {
      port = 9123;
      domain = "freshrss";
    };
    linkwarden = {
      port = 3000;
      domain = "lw";
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
in
{
  services.caddy = {
    enable = true;
    email = "me@frahz.dev";
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
      hash = "sha256-YZ4Bq0hfOJpa0C2lKipEY4fqwzJbEFM7ci5ys9S3uAo=";
    };
    globalConfig = ''
      acme_dns porkbun {
        api_key {env.PORKBUN_API_KEY}
        api_secret_key {env.PORKBUN_API_SECRET_KEY}
      }
    '';

    virtualHosts = {
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

  sops.secrets.porkbun = { };
  systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.secrets.porkbun.path;

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [
      80
      443
    ];
  };
}
