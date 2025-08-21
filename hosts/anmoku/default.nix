{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  casa = {
    profiles = {
      graphical.enable = true;
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
    system.bluetooth.enable = true;
    virtualisation.enable = true;
    networking = {
      tailscale.isClient = true;
      wirelessBackend = "iwd";
    };
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  programs = {
    adb.enable = true;
    hyprland.enable = true;
  };

  services = {
    flatpak.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };

  virtualisation.docker.enableOnBoot = false;

  security = {
    polkit.enable = true;
    soteria.enable = true;
    pam.services.hyprlock = { };
  };

  # Mullvad enable support: https://discourse.nixos.org/t/connected-to-mullvadvpn-but-no-internet-connection/35803/10?u=lion
  networking.resolvconf.enable = false;

}
