_: {
  services.scrutiny = {
    enable = true;
    openFirewall = true;
    settings.web = {
      listen.port = 9321;
    };
    collector.enable = true;
  };
}
