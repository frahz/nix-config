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
    programs.hyprland.enable = true;
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

  system.stateVersion = "23.11";
}
