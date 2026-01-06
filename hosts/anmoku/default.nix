{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  casa = {
    profiles = {
      graphical.enable = true;
      development.enable = true;
    };
    hardware = {
      cpu = "amd";
      gpu = "amd";
      enableHardwareAcceleration = true;
      capabilities = {
        bluetooth = true;
      };
      moondrop.enable = true;
    };
    shares.enable = true;
    system = {
      boot.silentBoot = true;
      bluetooth.enable = true;
    };
    virtualisation.enable = true;
    networking = {
      tailscale.isClient = true;
      wirelessBackend = "iwd";
    };
  };

  programs.hyprland.enable = true;

  environment.systemPackages = [
    pkgs.android-tools
  ];

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  virtualisation.docker.enableOnBoot = false;

  # Mullvad enable support: https://discourse.nixos.org/t/connected-to-mullvadvpn-but-no-internet-connection/35803/10?u=lion
  networking.resolvconf.enable = false;
}
