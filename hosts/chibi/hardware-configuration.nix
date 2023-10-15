
{ config, lib, pkgs, modulesPath, host, ...}:

{
    imports = [ ];

    boot = {
        initrd = {
            availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
            kernelModules = [ ];
        };
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
    };

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-uuid/e2d0aa33-9e54-4c56-a2ec-56cdd1221fda"; # TODO
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-uuid/401D-E8A4"; # TODO
            fsType = "vfat";
        };
    };

    swapDevices = [ ];

    networking = with host; {
        useDHCP = lib.mkDefault true;
        hostName = hostName;
    };
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
