
{ config, lib, pkgs, modulesPath, host, ...}:

{
    imports = [ ];

    boot = {
        initrd = {
            availableKernelModules = [ "xhci_pci" "ahci" "nvme" "ubs_storage" "usbhid" "sd_mod" ];
            kernelModules = [ ];
        };
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
    };

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-uuid/045641c5-b7de-468b-979f-565b1ee56803"; # TODO
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-uuid/94BB-A907"; # TODO
            fsType = "vfat";
        };
    };

    swapDevices = [ ];

    networking = with host; {
        useDHCP = lib.mkDefault true;
        hostName = hostName;
    };
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
