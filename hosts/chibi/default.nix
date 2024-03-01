{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/containers/pihole.nix
    ../../modules/containers/homarr.nix
    ../../modules/containers/nginxproxymanager.nix
    ../../modules/containers/linkwarden.nix
    ../../modules/containers/excalidraw.nix
    ../../modules/containers/freshrss.nix
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
    opengl = {
      # Hardware Accelerated Video
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

  # Secrets
  sops.secrets.raulyrs = {};

  # Services
  services = {
    sugoi.enable = true;

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
    samba = {
      enable = true;
      extraConfig = ''
        workgroup = WORKGROUP
        server string = inari server
        server role = standalone server
        pam password change = yes
        map to guest = bad user
        usershare allow guests = yes
      '';
      shares = {
        sharing = {
          path = "/mnt/kuki/sharing";
          comment = "shared directory";
          browseable = "yes";
          "read only" = "no";
          "inherit permissions" = "yes";
        };
      };
    };
    # TODO: fix the default `package` value in the raulyrs repo
    raulyrs = {
      enable = true;
      package = inputs.raulyrs.packages."x86_64-linux".default;
      environmentFile = config.sops.secrets.raulyrs.path;
    };
  };

  # Containers
  container = {
    pihole = {
      volumes = [
        "/mnt/kuki/containers/pihole/etc/pihole:/etc/pihole/"
        "/mnt/kuki/containers/pihole/etc/dnsmasq.d:/etc/dnsmasq.d"
      ];
    };
    homarr = {
      volumes = [
        "/mnt/kuki/containers/homarr/configs:/app/data/configs"
        "/mnt/kuki/containers/homarr/icons:/app/public/icons"
        "/mnt/kuki/containers/homarr/data:/data"
      ];
    };
    nginxproxymanager = {
      volumes = [
        "/mnt/kuki/containers/nginxproxymanager/data:/data"
        "/mnt/kuki/containers/nginxproxymanager/letsencrypt:/etc/letsencrypt"
      ];
    };
    linkwarden = {
      volumes = [
        "/mnt/kuki/containers/linkwarden/data:/data/data"
      ];
      pg_volumes = [
        "/mnt/kuki/containers/linkwarden/pg_data:/var/lib/postgresql/data"
      ];
      env_files = [/mnt/kuki/containers/linkwarden/linkwarden.env];
    };
    freshrss = {
      volumes = [
        "/mnt/kuki/containers/freshrss/config:/config"
      ];
    };
  };
}
