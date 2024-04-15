_: {
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "Hyprland";
        user = "frahz";
      };
      default_session = initial_session;
    };
  };
  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
