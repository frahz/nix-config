{
  config,
  pkgs,
  ...
}: {
  services.home-assistant = {
    enable = true;
    openFirewall = true;

    extraComponents = [
      "aranet"
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
      frontend = {
        themes = "!include_dir_merge_named themes";
      };

      "automation manual" = [
        {
          alias = "Set Default Theme on startup";
          trigger = [
            {
              platform = "homeassistant";
              event = "start";
            }
          ];
          action = [
            {
              service = "frontend.set_theme";
              data = {
                name = "Catppuccin Mocha";
              };
            }
          ];
        }
      ];
      "automation ui" = "!include automations.yaml";
      "scene ui" = "!include scenes.yaml";
    };

    customComponents = [
      pkgs.hass-smartrent
    ];
  };

  # prevent home-assistant fail to load when UI automations aren't defined yet
  systemd.tmpfiles.rules = [
    "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
    "f ${config.services.home-assistant.configDir}/scenes.yaml 0755 hass hass"
    "C ${config.services.home-assistant.configDir}/themes 0755 hass hass - ${pkgs.hass-catppuccin}/themes"
  ];

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
