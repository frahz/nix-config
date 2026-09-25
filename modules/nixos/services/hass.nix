{
  self,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.lists) singleton;
  inherit (self.lib) mkServiceOption mkSecret;

  cfg = config.casa.services.home-assistant;
  lanInterface = config.casa.networking.interfaces."10-lan" or "";
  rdomain = config.networking.domain;
in
{
  options.casa.services.home-assistant = mkServiceOption "home-assistant" {
    port = 8123;
    domain = "home.${rdomain}";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = lanInterface != "";
        message = "Home Assistant requires casa.networking.interfaces.\"10-lan\" to identify its LAN interface.";
      }
    ];

    sops.secrets = {
      home-assistant = mkSecret {
        file = "home-assistant";
        key = "env";
        owner = "hass";
        group = "hass";
        path = "${config.services.home-assistant.configDir}/secrets.yaml";
        restartUnits = [ "home-assistant.service" ];
      };
      mqtt-home-assistant-password = mkSecret {
        file = "home-assistant";
        key = "mqtt-home-assistant-password";
        restartUnits = [ "mosquitto.service" ];
      };
      mqtt-valetudo-password = mkSecret {
        file = "home-assistant";
        key = "mqtt-valetudo-password";
        restartUnits = [ "mosquitto.service" ];
      };
    };

    services.home-assistant = {
      enable = true;

      extraComponents = [
        "aranet"
        "cast"
        "isal"
        "met"
        "mqtt"
        # "google_translate"
        "radio_browser"
        "homekit"
        "hue"
        "zha"
      ];

      config = {
        default_config = { };
        homeassistant = {
          name = "Home";
          time_zone = "America/Los_Angeles";
          unit_system = "us_customary";
          temperature_unit = "F";
          country = "US";
          latitude = "!secret latitude";
          longitude = "!secret longitude";
        };
        # TODO: remove down the line due to HA deprecating for some reason
        http = {
          server_port = cfg.port;
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
        rest_command = {
          wakeup_server = {
            url = "https://sugoi.iatze.cc/api/wake";
            method = "POST";
            content_type = "application/x-www-form-urlencoded";
            payload = "mac_address=9C:6B:00:22:FC:96";
          };
          sleep_server = {
            url = "https://sugoi.iatze.cc/api/sleep";
            method = "POST";
            content_type = "application/x-www-form-urlencoded";
            payload = "address=inari:8253";
          };
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

      customComponents = singleton pkgs.home-assistant-custom-components.valetudo;

      customLovelaceModules = builtins.attrValues {
        inherit (pkgs.home-assistant-custom-lovelace-modules)
          apexcharts-card
          valetudo-map-card
          ;
      };

      extraPackages =
        python3Packages:
        builtins.attrValues {
          inherit (python3Packages)
            aiohomekit
            androidtvremote2

            # due to errors in UI
            getmac
            govee-ble
            ibeacon-ble
            oralb-ble
            pyatv
            python-otbr-api
            kegtron-ble
            samsungctl
            xiaomi-ble
            ;
        };
    };

    services.mosquitto = {
      enable = true;
      persistence = true;
      # TODO: convert to two listeners so that home-assistant can use localhost
      #       instead of LAN IP
      listeners = singleton {
        port = 1883;
        settings = {
          allow_anonymous = false;
          bind_interface = lanInterface;
          max_connections = 16;
        };
        users = {
          homeassistant = {
            passwordFile = config.sops.secrets.mqtt-home-assistant-password.path;
            acl = [
              "readwrite valetudo/#"
              "read homeassistant/#"
              "read homie/#"
            ];
          };
          valetudo = {
            passwordFile = config.sops.secrets.mqtt-valetudo-password.path;
            acl = [
              "readwrite valetudo/#"
              "write homeassistant/#"
              "readwrite homie/#"
            ];
          };
        };
      };
    };

    services.matterjs-server = {
      enable = true;
      bluetoothSupport = true;
    };

    # prevent home-assistant fail to load when UI automations aren't defined yet
    systemd.tmpfiles.rules = [
      "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
      "f ${config.services.home-assistant.configDir}/scenes.yaml 0755 hass hass"
      "C ${config.services.home-assistant.configDir}/themes 0755 hass hass - ${pkgs.home-assistant-themes.catppuccin}/themes"
    ];

    services.caddy.virtualHosts = {
      ${cfg.domain} = {
        extraConfig = ''
          reverse_proxy http://${cfg.host}:${toString cfg.port}
        '';
      };
      "valetudo.${rdomain}" = {
        extraConfig = ''
          reverse_proxy http://192.168.1.128:80
        '';
      };
    };

    networking.firewall.interfaces.${lanInterface} = {
      allowedTCPPorts = [
        1883 # MQTT/ Valetudo
        21063 # Homekit
        21064 # Homekit
        21065 # Homekit
      ];
      allowedUDPPorts = [
        5353 # Homekit
      ];
    };
  };
}
