{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/fonts.nix
    ../../modules/wayland
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

  environment.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  hardware = {
    pulseaudio.enable = false;
    nvidia = {
      powerManagement.enable = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable.overrideAttrs {
        src = pkgs.fetchurl {
          url = "https://download.nvidia.com/XFree86/Linux-x86_64/535.171.04/NVIDIA-Linux-x86_64-535.171.04.run";
          sha256 = "0yj38aljmnr0c533d4hl5xjf9b3xm620fix4cp6qlpf99cxn9wg8";
        };
      };
    };
    opengl = {
      enable = true;
      extraPackages = [pkgs.nvidia-vaapi-driver];
    };
  };

  networking.networkmanager.enable = true;
}
