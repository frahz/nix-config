{
  imports = [
    ../base
    ./boot
    ./catppuccin.nix
    ./containers
    ./environment
    ./gaming.nix
    ./hardware
    ./misc.nix
    ./networking
    ./nh.nix
    ./programs
    ./server.nix
    ./services
    ./sops.nix
    ./system
    ./virtualisation.nix
  ];

  system.stateVersion = "23.11";
}
