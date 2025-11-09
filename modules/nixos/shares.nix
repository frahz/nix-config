{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.casa.shares;
in
{
  options.casa.shares = {
    enable = mkEnableOption "Enable mounting samba shares";
    music = {
      enable = mkEnableOption "music share" // {
        default = true;
      };
    };
    sharing = {
      enable = mkEnableOption "data share" // {
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.tailscale.enable;
        message = "CIFS connects to chibi shares over tailscale, but services.tailscale.enable != true.";
      }
    ];

    # SMB share, move to different location after
    sops.secrets.smb-secrets = {
      path = "/etc/nixos/smb-secrets";
    };

    environment.systemPackages = with pkgs; [
      cifs-utils
    ];

    fileSystems =
      let
        fsType = "cifs";
        options = [
          "noauto"
          "x-systemd.automount"
          "x-systemd.device-timeout=5s"
          "x-systemd.idle-timeout=60"
          "x-systemd.mount-timeout=5s"
          "user"
          "users"
          "credentials=${config.sops.secrets.smb-secrets.path}"
          "uid=${toString config.users.users.frahz.uid}"
          "gid=100"
        ];
      in
      {
        "/home/frahz/sharing" = mkIf cfg.sharing.enable {
          inherit fsType options;
          device = "//chibi/sharing";
        };
        "/home/frahz/Music" = mkIf cfg.music.enable {
          inherit fsType options;
          device = "//chibi/music";
        };
      };
  };
}
