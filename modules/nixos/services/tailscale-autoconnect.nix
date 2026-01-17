{
  self,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.types) str;
  inherit (lib) mkIf mkOption;
  inherit (self.lib) mkServiceOption;

  cfg = config.casa.services.tailscale-autoconnect;
in
{
  options.casa.services.tailscale-autoconnect = mkServiceOption "tailscale-autoconnect" { } // {
    authKeyFile = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";

      # make sure tailscale is running before trying to connect to tailscale
      after = [
        "network-pre.target"
        "tailscale.service"
      ];
      wants = [
        "network-pre.target"
        "tailscale.service"
      ];
      wantedBy = [ "multi-user.target" ];

      # set this service as a oneshot job
      serviceConfig.Type = "oneshot";

      # have the job run this shell script
      script = ''
        # wait for tailscaled to settle
        sleep 2

        # check if we are already authenticated to tailscale
        status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
        fi

        # otherwise authenticate with tailscale
        ${pkgs.tailscale}/bin/tailscale up --authkey file:${cfg.authKeyFile} --operator=frahz
      '';
    };
  };
}
