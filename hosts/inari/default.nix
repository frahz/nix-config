{ config, lib, pkgs, ...}:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/containers/torrent.nix
        ../../modules/containers/sonarr.nix
        ../../modules/containers/radarr.nix
        /* ../../modules/containers/kavita.nix */
        ../../modules/containers/gitea.nix
        ../../modules/containers/jellyseerr.nix
        ../../modules/containers/jellyfin.nix
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
        swraid = {
            enable = true;
            mdadmConf = ''
                HOMEHOST <system>
                MAILADDR root
                ARRAY /dev/md/yanai:0 metadata=1.2 name=yanai:0 UUID=dbb1c332:9130b9ad:e2d8640b:7a533ded
            '';
        };
    };

    hardware = {
        opengl = { # Hardware Accelerated Video
            enable = true;
            extraPackages = with pkgs; [
                intel-media-driver
                vaapiIntel
                vaapiVdpau
                libvdpau-va-gl
                intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
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

    # Containers
    sops.secrets.gluetun = {};
    container.torrent = {
        qb_volumes = [
            "/mnt/mizu/torrents:/torrents"
            "/mnt/mizu/containers/qbittorrent/config:/config"
        ];
        gluetun_volumes = [
            "/mnt/mizu/containers/gluetun/config:/config"
            "/mnt/mizu/containers/gluetun/servers.json:/gluetun/servers.json"
        ];
        vpn_info_file = config.sops.secrets.gluetun.path;
    };

    container.sonarr = {
        volumes = [
            "/mnt/mizu/containers/sonarr/config:/config"
            "/mnt/mizu:/data"
        ];
    };
    container.radarr = {
        volumes = [
            "/mnt/mizu/containers/radarr/config:/config"
            "/mnt/mizu:/data"
        ];
    };

    /* container.kavita = { */
    /*     volumes = [ */
    /*         "/mnt/mizu/containers/kavita/config:/kavita/config" */
    /*             "/mnt/mizu/library/manga:/manga" */
    /*             "/mnt/mizu/library/lightnovels:/lightnovels" */
    /*     ]; */
    /* }; */

    container.jellyseerr = {
        volumes = [
            "/mnt/mizu/containers/jellyseer/config:/app/config"
        ];
    };

    container.jellyfin = {
        volumes = [
            "/mnt/mizu/containers/jellyfin/config:/config"
            "/mnt/mizu/containers/jellyfin/cache:/cache"
            "/mnt/mizu/media:/media"
        ];
    };

    sops.secrets.gitea = {};
    container.gitea = {
        gitea_volumes = [
            "/mnt/mizu/containers/gitea/data:/data"
            "/etc/timezone:/etc/timezone:ro"
        ];
        pg_volumes = [
            "/mnt/mizu/containers/gitea/postgres:/var/lib/postgresql/data"
        ];
        runner_volumes = [
            "/mnt/mizu/containers/gitea_runner/config.yaml:/config.yaml"
            "/mnt/mizu/containers/gitea_runner/data:/data"
            "/var/run/docker.sock/:/var/run/docker.sock"
        ];
        env_file = config.sops.secrets.gitea.path;
    };

}
