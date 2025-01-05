{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default
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
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      # enable amdgpu xorg drivers
      videoDrivers = ["amdgpu"];
    };

    gvfs.enable = true;
    tumbler.enable = true;
    udisks2.enable = true;

    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2fc6", MODE="0666"
    '';
  };
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.hyprlock = {};
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

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };
  # Mullvad enable support: https://discourse.nixos.org/t/connected-to-mullvadvpn-but-no-internet-connection/35803/10?u=lion
  networking.resolvconf.enable = false;
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    domains = ["~."];
    fallbackDns = ["1.1.1.1" "8.8.8.8"];
    dnsovertls = "true";
  };
}
