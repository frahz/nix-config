{
  lib,
  config,
  ...
}:
{
  fileSystems."/" = {
    device = "/dev/disk/by-label/main";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  networking = {
    useDHCP = lib.mkDefault true;
  };
}
