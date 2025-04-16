_: {
  imports = [
    # ./tailray.nix
  ];

  services.udiskie = {
    enable = true;
    tray = "never";
  };
}
