_: {
  services.scrutiny = {
    enable = true;
    openFirewall = true;
    settings.web = {
      listen.port = 9321;
      influxdb.port = 9327;
    };
    collector.enable = true;
  };
}
