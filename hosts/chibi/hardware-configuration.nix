{
  config,
  lib,
  ...
}:
{
  imports = [ ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

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

  swapDevices = [ ];

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "chibi";
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
