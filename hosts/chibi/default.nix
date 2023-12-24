{ lib, pkgs, ...}:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/containers/pihole.nix
        ../../modules/containers/homarr.nix
        ../../modules/containers/nginxproxymanager.nix
        ../../modules/containers/linkwarden.nix
        ../../modules/containers/excalidraw.nix
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

    container.homarr = {
        volumes = [
            "/mnt/kuki/containers/homarr/configs:/app/data/configs"
            "/mnt/kuki/containers/homarr/icons:/app/public/icons"
            "/mnt/kuki/containers/homarr/data:/data"
        ];
    };
    container.nginxproxymanager = {
        volumes = [
            "/mnt/kuki/containers/nginxproxymanager/data:/data"
            "/mnt/kuki/containers/nginxproxymanager/letsencrypt:/etc/letsencrypt"
        ];
    };
    container.linkwarden = {
        volumes = [
            "/mnt/kuki/containers/linkwarden/data:/data/data"
        ];
        pg_volumes = [
            "/mnt/kuki/containers/linkwarden/pg_data:/var/lib/postgresql/data"
        ];
        env_files = [ /mnt/kuki/containers/linkwarden/linkwarden.env ];
    };

}
