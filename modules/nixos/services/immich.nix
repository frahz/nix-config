{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption;

  cfg = config.casa.services.immich;
  rdomain = config.networking.domain;
  mediaDir = "${cfg.storagePath}/photos";
in
{
  options.casa.services.immich = mkServiceOption "immich" {
    host = "0.0.0.0";
    port = 2283;
    domain = "photos.${rdomain}";
  };

  config = mkIf cfg.enable {
    sops.secrets.immich = { };
    services.immich = {
      inherit (cfg) host;
      enable = true;
      openFirewall = true;
      secretsFile = config.sops.secrets.immich.path;
      redis = {
        enable = true;
      };
      accelerationDevices = [
        "/dev/dri/renderD128"
      ];
    };

    users.users.immich.extraGroups = [
      "video"
      "render"
    ];

    systemd.tmpfiles.rules = [
      "d ${mediaDir} 0775 immich immich - -"
    ];

    # Workaround
    fileSystems."/var/lib/immich" = {
      device = mediaDir;
      options = [ "bind" ];
    };

    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
