{ lib, pkgs, ...}:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/containers/pihole.nix
    ];

    boot = {
        loader = {
            systemd-boot = {
                enable = true;
                configurationLimit = 3;
            };
            efi = {
                canTouchEfiVariables = true;
            };
            timeout = 5;
        };
        kernelPackages = pkgs.linuxPackages_latest;
    };

    hardware = {
        opengl = { # Hardware Accelerated Video
            enable = true;
            extraPackages = with pkgs; [
                intel-media-driver
                vaapiIntel
                vaapiVdpau
                libvdpau-va-gl
            ];
        };
    };

    environment.systemPackages = with pkgs; [
        hugo
    ];

    virtualisation.docker = {
        enable = true;
        autoPrune.enable = true;
    };

}
