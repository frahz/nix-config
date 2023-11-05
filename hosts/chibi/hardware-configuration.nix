
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
            device = "/dev/disk/by-uuid/2c69de82-1d9c-49bc-8402-d1fddadb4703"; # TODO
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-uuid/3965-6BBA"; # TODO
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
