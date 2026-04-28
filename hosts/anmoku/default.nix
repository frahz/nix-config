{ lib, pkgs, ... }:
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
    virtualisation = {
      enable = true;
      enableOnBoot = false;
    };
    networking = {
      tailscale.isClient = true;
    };
  };

  programs = {
    firejail = {
      enable = true;
      wrappedBinaries = {
        vesktop = {
          executable = "${lib.getExe pkgs.vesktop}";
          desktop = "${pkgs.vesktop}/share/applications/vesktop.desktop";
          extraArgs = [
            "--net=wlan0"
            "--noprofile"
          ];
        };
      };
    };
    hyprland = {
      enable = true;
    };
  };
}
