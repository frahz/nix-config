{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/wayland
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
    };
    system.bluetooth.enable = true;
    virtualisation.enable = true;
    networking = {
      tailscale.isClient = true;
    };
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

  virtualisation.docker.enableOnBoot = false;

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    soteria.enable = true;
    pam.services.hyprlock = { };
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
    # Mullvad enable support: https://discourse.nixos.org/t/connected-to-mullvadvpn-but-no-internet-connection/35803/10?u=lion
    resolvconf.enable = false;
  };
}
