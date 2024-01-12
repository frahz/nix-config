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
            device = "/dev/disk/by-uuid/793aa3c1-d841-48f1-a615-177f90abc503";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-uuid/BC28-BF3A";
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
    # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
    # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
