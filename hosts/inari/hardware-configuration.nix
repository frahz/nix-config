{
  lib,
  config,
  ...
}:
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/793aa3c1-d841-48f1-a615-177f90abc503";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/BC28-BF3A";
      fsType = "vfat";
    };
    "/mnt/mizu" = {
      device = "/dev/disk/by-uuid/e2ebcdeb-7d33-4004-a4f9-147b45d45bc5";
      fsType = "ext4";
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
