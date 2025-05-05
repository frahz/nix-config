{config, ...}: let
  mediaDir = "/mnt/kuki/photos";
in {
  sops.secrets.immich = {};
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

  users.users.immich.extraGroups = ["video" "render"];

  services.caddy.virtualHosts."photos.iatze.cc" = let
    cfg = config.services.immich;
  in {
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
    options = ["bind"];
    neededForBoot = true; # if necessary
  };
}
