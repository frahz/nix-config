{
  config,
  lib,
  host,
  modulesPath,
  ...
}: {
  imports = [];

  boot = {
    initrd = {
      availableKernelModules = ["sd_mod" "sr_mod"];
      kernelModules = [];
    };
    kernelModules = [];
    extraModulePackages = [];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ecc544f6-77d8-4bc8-9a2b-4275a48847e2";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F33A-98F9";
    fsType = "vfat";
  };

  swapDevices = [];

  networking = with host; {
    useDHCP = lib.mkDefault true;
    inherit hostName;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.hypervGuest.enable = true;
}
