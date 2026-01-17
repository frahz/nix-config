{
  config,
  ...
}:
let
  inherit (config.casa.profiles.server) domain;

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
  services.caddy.virtualHosts = {
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

}
