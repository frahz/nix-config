{
  config,
  ...
}:
let
  inherit (config.casa.profiles.server) domain storage;

  cfg = config.services.immich;
  mediaDir = "${storage}/photos";
in
{
  sops.secrets.immich = { };
  services.immich = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
    secretsFile = config.sops.secrets.immich.path;
    redis = {
      enable = true;
    };
    accelerationDevices = [
      "/dev/dri/renderD128"
    ];
  };

  # https://github.com/NixOS/nixpkgs/pull/454606

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  services.caddy.virtualHosts."photos.${domain}" = {
    extraConfig = ''
      reverse_proxy http://${cfg.host}:${toString cfg.port}
    '';
  };

  systemd.tmpfiles.rules = [
    "d ${mediaDir} 0775 immich immich - -"
  ];

  # Workaround
  fileSystems."/var/lib/immich" = {
    device = mediaDir;
    options = [ "bind" ];
  };
}
