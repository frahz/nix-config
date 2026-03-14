{
  # enable wireless database, it helps keeping wifi speedy
  hardware.wirelessRegulatoryDatabase = true;

  networking.wireless = {
    # wpa_supplicant
    extraConfig = ''
      update_config=1
    '';

    iwd = {
      settings = {
        Settings = {
          AutoConnect = true;
        };

        Network = {
          EnableIPv6 = true;
          RoutePriorityOffset = 300;
        };
      };
    };
  };
}
