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

  programs.hyprland = {
    enable = true;
    #  finalPackage = inputs.hyprland.packages.${pkgs.system}.default;
    portalPackage = inputs.xdg-portal-hyprland.packages.${pkgs.system}.default;
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  hardware.pulseaudio.enable = false;

  networking.networkmanager.enable = true;
}
