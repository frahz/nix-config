_: {
  services.navidrome = {
    enable = true;
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/mnt/kuki/music";
    };
    openFirewall = true;
  };
}
