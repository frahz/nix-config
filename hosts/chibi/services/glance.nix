{config, ...}: {
  sops.secrets.glance = {};
  systemd.services.glance = {
    serviceConfig.EnvironmentFile = config.sops.secrets.glance.path;
  };

  services.glance = {
    enable = true;
    openFirewall = true;
    settings = {
      server = {
        host = "0.0.0.0";
        port = 7576;
      };
      branding = {
        hide-footer = true;
      };
      theme = {
        background-color = "240 21 15";
        contrast-multiplier = 1.3;
        primary-color = "316 72 86";
        positive-color = "115 54 76";
        negative-color = "347 70 65";
      };
      pages = [
        {
          name = "Home";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "calendar";
                }
                {
                  type = "dns-stats";
                  service = "adguard";
                  url = "https://adguard.iatze.cc";
                  username = "frahz";
                  password = "\${ADGUARD_PASSWORD}";
                }
                {
                  type = "twitch-channels";
                  channels = [
                    "theprimeagen"
                    "s0mcs"
                    "tarik"
                    "Ottomated"
                    "hyoon"
                    "zanderfps"
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "monitor";
                  title = "Services";
                  style = "dynamic-columns-experimental";
                  cache = "30m";
                  sites = [
                    {
                      title = "jellyfin";
                      url = "https://jellyfin.iatze.cc";
                      icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/svg/jellyfin.svg";
                    }
                    {
                      title = "scrutiny";
                      url = "https://scrutiny.iatze.cc";
                      icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/svg/scrutiny.svg";
                    }
                    {
                      title = "sonarr";
                      url = "https://sonarr.iatze.cc";
                      icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/svg/sonarr.svg";
                    }
                    {
                      title = "forgejo";
                      url = "https://git.iatze.cc";
                      icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/svg/forgejo.svg";
                    }
                    {
                      title = "adguard";
                      url = "https://adguard.iatze.cc";
                      icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/svg/adguard-home.svg";
                    }
                    {
                      title = "radarr";
                      url = "https://radarr.iatze.cc";
                      icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/svg/radarr.svg";
                    }
                    {
                      title = "jellyseerr";
                      url = "https://jellyseerr.iatze.cc";
                      icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/svg/jellyseerr.svg";
                    }
                    {
                      title = "kavita";
                      url = "https://kavita.iatze.cc";
                      icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/svg/kavita.svg";
                    }
                    {
                      title = "freshrss";
                      url = "https://freshrss.iatze.cc";
                      icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/svg/freshrss.svg";
                    }
                    {
                      title = "qbittorrent";
                      url = "https://qb.iatze.cc";
                      icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/svg/qbittorrent.svg";
                    }
                    {
                      title = "linkwarden";
                      url = "https://lw.iatze.cc";
                      icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/linkwarden.png";
                    }
                    {
                      title = "navidrome";
                      url = "https://music.iatze.cc";
                      icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/svg/navidrome.svg";
                    }
                  ];
                }
                {
                  type = "group";
                  widgets = let
                    shared-properties = {
                      collapse-after = 10;
                      limit = 13;
                      cache = "1h";
                    };
                  in [
                    ({
                        type = "hacker-news";
                      }
                      // shared-properties)
                    ({
                        type = "rss";
                        feeds = [
                          {
                            url = "https://freshrss.iatze.cc/i/?a=rss&state=3";
                            title = "FreshRSS";
                          }
                        ];
                      }
                      // shared-properties)
                    ({
                        type = "reddit";
                        subreddit = "selfhosted";
                      }
                      // shared-properties)
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  location = "San Diego, California, United States";
                  units = "imperial";
                }
                {
                  type = "bookmarks";
                  style = "dynamic-columns-experimental";
                  groups = [
                    {
                      color = "267 84 81";
                      links = [
                        {
                          title = "Proton Mail";
                          url = "https://mail.proton.me/u/0/inbox";
                        }
                        {
                          title = "GitHub";
                          url = "https://github.com";
                        }
                        {
                          title = "AniList";
                          url = "https://anilist.co/home";
                        }
                      ];
                    }
                    {
                      title = "Entertainment";
                      color = "316 72 86";
                      links = [
                        {
                          title = "Crunchyroll";
                          url = "https://www.crunchyroll.com/watchlist";
                        }
                        {
                          title = "Paramount";
                          url = "https://www.paramountplus.com";
                        }
                        {
                          title = "Peacock";
                          url = "https://www.peacocktv.com";
                        }
                        {
                          title = "MangaDex";
                          url = "https://mangadex.org";
                        }
                      ];
                    }
                    {
                      title = "Other";
                      color = "23 92 75";
                      links = [
                        {
                          title = "Mastodon";
                          url = "https://phanpy.social/";
                        }
                        {
                          title = "Claude";
                          url = "https://claude.ai/";
                        }
                        {
                          title = "SeaDex";
                          url = "https://releases.moe/";
                        }
                        {
                          title = "Sneedex";
                          url = "https://sneedex.moe/";
                        }
                      ];
                    }
                  ];
                }
                {
                  type = "markets";
                  stocks = [
                    {
                      symbol = "SPY";
                      name = "S&P 500";
                    }
                    {
                      symbol = "QCOM";
                      name = "Qualcomm";
                    }
                    {
                      symbol = "NVDA";
                      name = "NVIDIA";
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
