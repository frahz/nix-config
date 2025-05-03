{
  config,
  pkgs,
  ...
}: {
  services.home-assistant = {
    enable = true;
    openFirewall = true;

    extraComponents = [
      "cast"
      "isal"
      "met"
      "google_translate"
      "radio_browser"
      "homekit"
      "hue"
    ];

    config = {
      default_config = {};
      homeassistant = {
        name = "Home";
        time_zone = "America/Los_Angeles";
        unit_system = "us_customary";
        temperature_unit = "F";
        country = "US";
      };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "100.87.38.99"
          "127.0.0.1"
          "::1"
        ];
      };
    };

    customComponents = [
      pkgs.hass-smartrent
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      21063 # Homekit
      21064 # Homekit
      21065 # Homekit
    ];
    allowedUDPPorts = [
      5353 # Homekit
    ];
  };
}
