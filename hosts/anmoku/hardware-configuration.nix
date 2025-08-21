{
  # SMB share, move to different location after
  sops.secrets.smb-secrets = {
    path = "/etc/nixos/smb-secrets";
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/main";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    "/home/frahz/sharing" = {
      device = "//chibi/sharing";
      fsType = "cifs";
      options =
        let
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        in
        [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100" ];
    };
  };
}
