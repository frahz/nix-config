{ config, lib, pkgs, ...}:

{
    imports = [
        ./hardware-configuration.nix
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

    virtualisation = {
        oci-containers.backend = "docker";
        docker = {
            enable = true;
            autoPrune.enable = true;
        };
    };

    # Services
    sops.secrets.tsauth-inari = {};
    services.tailscale-autoconnect = {
        enable = true;
        authKeyFile = config.sops.secrets.tsauth-inari.path;
    };

    services.nemui.enable = true;
}
