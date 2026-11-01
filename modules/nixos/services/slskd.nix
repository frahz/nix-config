{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption mkSecret;
  inherit (config.casa.profiles.server) storage;

  cfg = config.casa.services.slskd;
  rdomain = config.networking.domain;
in
{
  options.casa.services.slskd = mkServiceOption "slskd" {
    port = 3018;
    domain = "soulseek.${rdomain}";
    storagePath = storage;
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = builtins.compareVersions config.services.slskd.package.version "0.26.1" <= 0;
        message = ''
          slskd is newer than 0.26.1: remove the mutex workaround (XDG_RUNTIME_DIR,
          RuntimeDirectory, and RuntimeDirectoryMode) and this assertion.
          Fixed upstream in 0.26.2: https://github.com/slskd/slskd/pull/1893
        '';
      }
    ];

    sops.secrets.slskd = mkSecret {
      file = "slskd";
      key = "env";
    };
    services.slskd = {
      enable = true;
      group = "users";

      environmentFile = config.sops.secrets.slskd.path;

      settings = {
        web = {
          inherit (cfg) port;
          ip_address = cfg.host;
        };

        transfers.download.destination.permissions.mode = 775;

        directories = {
          incomplete = "${cfg.storagePath}/downloads/music";
          downloads = "${cfg.storagePath}/music";
        };

        # shares.directories = [ "${cfg.storagePath}/music" ];
      };

    };
    systemd.services.slskd = {
      # .NET's user-scoped mutex needs a writable runtime directory.
      # Upstream fix: https://github.com/slskd/slskd/pull/1893
      environment.XDG_RUNTIME_DIR = "/run/slskd";
      serviceConfig = {
        RuntimeDirectory = "slskd";
        RuntimeDirectoryMode = "0700";
        UMask = "0002";
      };
    };

    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
