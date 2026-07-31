{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/ce96c3b7-0044-431e-b1e5-b5f582fcd4de";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/5432-A65E";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };
}
