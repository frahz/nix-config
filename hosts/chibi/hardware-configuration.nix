{
  config,
  lib,
  ...
}:
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/2c69de82-1d9c-49bc-8402-d1fddadb4703";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/3965-6BBA";
      fsType = "vfat";
    };
    "/mnt/kuki" = {
      device = "/dev/disk/by-uuid/dca6c8c2-c5e4-4c4d-9641-06306f102bf0";
      fsType = "ext4";
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
