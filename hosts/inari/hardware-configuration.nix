{ config, lib, pkgs, host, ...}:

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
            device = "/dev/disk/by-uuid/TODO";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-uuid/TODO";
            fsType = "vfat";
        };
        /* "/mnt/mizu" = { */
        /*     device = "/dev/disk/by-uuid/TODO"; */
        /*     fsType = "ext4"; */
        /* }; */
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
