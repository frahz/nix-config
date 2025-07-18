{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/fonts.nix
    ../../modules/wayland
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi = {
        canTouchEfiVariables = true;
      };
      timeout = 5;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  environment.systemPackages = with pkgs; [
    libnotify
    cifs-utils
  ];

  programs = {
    adb.enable = true;
    hyprland.enable = true;

    # gaming
    gamemode.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin.steamcompattool
      ];
    };
  };

  services = {
    blueman.enable = true;
    flatpak.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    tailscale.useRoutingFeatures = "client";
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      # enable amdgpu xorg drivers
      videoDrivers = [ "amdgpu" ];
    };

    gvfs.enable = true;
    tumbler.enable = true;
    udisks2.enable = true;

    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    udev.extraRules = ''
      # Moondrop DAC
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2fc6", MODE="0666"
      # These two devices cause sleep to fail the first time
      # USB XHC0 = keyboard
      # USB XHC1 = mouse
      ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1022" ATTR{device}=="0x161d" ATTR{power/wakeup}="disabled"
      ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1022" ATTR{device}=="0x161e" ATTR{power/wakeup}="disabled"
    '';
  };

  virtualisation = {
    oci-containers.backend = "docker";
    docker = {
      enable = true;
      enableOnBoot = false;
      autoPrune.enable = true;
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    soteria.enable = true;
    pam.services.hyprlock = { };
  };

  hardware = {
    bluetooth.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
      # enables AMDVLK & OpenCL support
      extraPackages = with pkgs; [
        # opencl drivers
        # rocm-opencl-icd
        # rocm-opencl-runtime
        amdvlk

        # mesa
        mesa

        # vulkan
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
      ];
    };
  };

  # SMB share, move to different location after
  sops.secrets.smb-secrets = {
    path = "/etc/nixos/smb-secrets";
  };
  fileSystems."/home/frahz/sharing" = {
    device = "//chibi/sharing";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in
      [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100" ];
  };

  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      # wifi.backend = "iwd";
    };
    nameservers = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
    # Mullvad enable support: https://discourse.nixos.org/t/connected-to-mullvadvpn-but-no-internet-connection/35803/10?u=lion
    resolvconf.enable = false;
    # wireless = {
    #   iwd = {
    #     enable = true;
    #     settings = {
    #       Settings.AutoConnect = true;
    #       General = {
    #         EnableNetworkConfiguration = true;
    #       };
    #       Network = {
    #         EnableIPv6 = true;
    #         RoutePriorityOffset = 300;
    #       };
    #     };
    #  };
    # };
  };
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    dnsovertls = "true";
  };
}
