{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../users/frahz
    # TODO: make a default thing for these two
    ../modules/nix.nix
    ../modules/nh.nix
    ../modules/services
    ../modules/shell
  ];

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  environment = {
    systemPackages = with pkgs; [
      bat
      ripgrep
      binutils
      coreutils
      docker
      fd
      git
      btop
      jq
      neovim
      tokei
      wget
      lazydocker
      tailscale
      tmux
    ];
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
  };

  /*
  networking.networkmanager.enable = true;
  */

  system.stateVersion = "23.11";
}
