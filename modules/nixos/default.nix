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
    ./security.nix
    ./server.nix
    ./services
    ./shares.nix
    ./sops.nix
    ./system
    ./virtualisation.nix
  ];

  system.stateVersion = "23.11";
}
