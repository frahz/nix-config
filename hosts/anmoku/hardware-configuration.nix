{
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

  };

  networking.firewall.extraInputRules = ''
    iifname "wlan0" ip saddr 192.168.1.226 meta l4proto tcp accept
  '';
}
