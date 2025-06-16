{config, ...}: let
  host = "0.0.0.0";
  port = 7576;
in {
  sops.secrets.glance = {};

  services.caddy.virtualHosts.${config.homelab.domain} = {
    extraConfig = ''
      reverse_proxy http://${host}:${toString port}
    '';
  };

  services.glance = {
    enable = true;
    openFirewall = true;
    environmentFile = config.sops.secrets.glance.path;
    settings = {
      server = {
        inherit host;
        inherit port;
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
                # TODO: add media-requests widget here: https://github.com/glanceapp/glance/pull/345
                {
                  type = "custom-api";
                  title = "Media Requests";
                  cache = "20m";
                  options = {
                    base-url = "https://jellyseerr.iatze.cc";
                    api-key = "\${JELLYSEERR_API_KEY}";
                    limit = 20;
                    collapse-after = 5;
                  };
                  template = ''
                    {{ $baseURL := .Options.StringOr "base-url" "" }}
                    {{ $apiKey := .Options.StringOr "api-key" "" }}

                    {{ define "errorMsg" }}
                      <div class="widget-error-header">
                        <div class="color-negative size-h3">ERROR</div>
                        <svg class="widget-error-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z"></path>
                        </svg>
                      </div>
                      <p class="break-all">{{ . }}</p>
                    {{ end }}

                    {{ if or
                      (eq $baseURL "")
                      (eq $apiKey "")
                    }}
                      {{ template "errorMsg" "Some required options are not set" }}
                    {{ else }}

                    {{ $limit := .Options.IntOr "limit" 20 }}
                    {{ $collapseAfter := .Options.IntOr "collapse-after" 5 }}
                    {{ $requestUrl := printf "%s/api/v1/request?take=%d&sort=added&sortDirection=desc" $baseURL $limit}}
                    {{ $responseCall := "" }}
                    {{ $response := "" }}

                    <style>
                      .media-requests-thumbnail {
                        width: 5rem;
                        aspect-ratio: 3 / 4;
                        border-radius: var(--border-radius);
                      }
                      .color-purple { color: hsl(267deg, 84%, 81%); }
                      .color-yellow { color: hsl(41deg, 86%, 83%); }
                      .color-blue   { color: hsl(217deg, 92%, 76%); }
                    </style>

                    {{ $responseCall = newRequest $requestUrl
                      | withHeader "X-Api-Key" $apiKey
                      | withHeader "Accept" "application/json"
                      | getResponse }}

                    {{ if ne $responseCall.Response.StatusCode 200 }}
                      {{ template "errorMsg" "Could not fetch Jellyseerr API." }}
                    {{ else }}
                      {{ $response = $responseCall.JSON.Array "results" }}
                      <ul class="list list-gap-14 collapsible-container" data-collapse-after="{{ $collapseAfter }}">
                          {{ range $response }}
                            {{ $id := .Int "id" }}
                            {{ $status := .Int "status" }}
                            {{ $type := .String "type" }}

                            {{ $mediaId := .Int "media.id" }}
                            {{ $mediaTmdbId := .Int "media.tmdbId" }}
                            {{ $mediaStatus := .Int "media.status" }}
                            {{ $mediaType := .String "media.mediaType" }}

                            {{ $mediaLink := printf "%s/%s/%d" $baseURL $type $mediaTmdbId }}

                            {{ $userDisplayName := .String "requestedBy.displayName" }}
                            {{ $userId := .Int "requestedBy.id" }}
                            {{ $userAvatar := .String "requestedBy.Avatar" }}
                            {{ $userLink := printf "%s/users/%d" $baseURL $userId }}

                            {{ $itemName := "" }}
                            {{ $itemBackdropPath := "" }}
                            {{ $itemPosterPath := "" }}
                            {{ $itemAirDate := "" }}
                            {{ $itemInfoUrl := printf "%s/api/v1/%s/%d" $baseURL $mediaType $mediaTmdbId }}
                            {{ $popoverSummary := "TBA" }}
                            {{ $genres := "" }}


                            {{ $infoCall := newRequest $itemInfoUrl
                              | withHeader "X-Api-Key" $apiKey
                              | withHeader "Accept" "application/json"
                              | getResponse }}

                            {{ if eq $infoCall.Response.StatusCode 200 }}
                              {{ $itemBackdropPath = $infoCall.JSON.String "backdropPath" }}
                              {{ $itemPosterPath = $infoCall.JSON.String "posterPath" }}
                              {{ $popoverSummary = $infoCall.JSON.String "overview" }}
                              {{ $genres = $infoCall.JSON.Array "genres" }}

                              {{ if eq $mediaType "tv" }}
                                  {{ $itemName = $infoCall.JSON.String "name" }}
                                  {{ $itemAirDate = $infoCall.JSON.String "firstAirDate" }}
                              {{ else }}
                                  {{ $itemName = $infoCall.JSON.String "title" }}
                                  {{ $itemAirDate = $infoCall.JSON.String "releaseDate" }}
                              {{ end }}
                            {{ end }}

                            {{ $posterImageUrl := concat "https://image.tmdb.org/t/p/w600_and_h900_bestv2/" $itemPosterPath }}

                            <li class="media-requests thumbnail-parent">
                                <div class="flex gap-10 items-start">
                                    <div>
                                       <div data-popover-type="html" data-popover-position="above" data-popover-show-delay="500" style=" align-content: center;">
                                         <div data-popover-html>
                                           <div style="margin: 5px;">
                                             <a class="size-h4 color-primary" href="{{ $mediaLink }}" target="_blank" rel="noreferrer" title="{{ $itemName }}">{{ $itemName }}</a>
                                             <p class="margin-top-20" style="overflow-y: auto; text-align: justify; max-height: 20rem;">
                                               {{ if ne $popoverSummary "" }}
                                                 {{ $popoverSummary }}
                                               {{ else }}
                                                 TBA
                                               {{ end }}
                                             </p>
                                             {{ if gt (len $genres) 0 }}
                                             <ul class="attachments margin-top-20">
                                               {{ range $genres }}
                                                 <li>{{ .String "name" }}</li>
                                               {{ end }}
                                             </ul>
                                             {{ end }}
                                          </div>
                                        </div>
                                        <img class="media-requests-thumbnail thumbnail" loading="lazy" src="{{ $posterImageUrl }}" alt="">
                                      </div>
                                    </div>
                                    <div class="min-width-0">
                                        <a class="title size-h3 color-highlight text-truncate block" href="{{ $mediaLink }}" target="_blank" rel="noreferrer" title="{{ $itemName }}">
                                            {{ $itemName }}
                                        </a>
                                        <ul class="list-horizontal-text">
                                            {{ if eq $mediaStatus 5 }}
                                            <li class="color-positive">Available</li>
                                            {{ else if eq $mediaStatus 4 }}
                                            <li class="color-yellow">Partial</li>
                                            {{ else if eq $mediaStatus 3 }}
                                            <li class="color-blue">Processing</li>
                                            {{ else if eq $mediaStatus 2 }}
                                            <li class="color-purple">Pending Approval</li>
                                            {{ else }}
                                            <li class="color-negative">Unknown</li>
                                            {{ end }}
                                        </ul>
                                        <ul class="list-horizontal-text flex-nowrap">
                                            <li>{{ $itemAirDate }}</li>
                                            <li class="min-width-0">
                                                <a class="color-primary" href="{{ $userLink }}" target="_blank" rel="noreferrer">{{ $userDisplayName }}</a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </li>
                          {{ end }}
                      </ul>
                    {{ end }}

                    {{ end }}
                  '';
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
                      icon = "di:jellyfin";
                    }
                    {
                      title = "scrutiny";
                      url = "https://scrutiny.iatze.cc";
                      icon = "di:scrutiny";
                    }
                    {
                      title = "sonarr";
                      url = "https://sonarr.iatze.cc";
                      icon = "di:sonarr";
                    }
                    {
                      title = "forgejo";
                      url = "https://git.iatze.cc";
                      icon = "di:forgejo";
                    }
                    {
                      title = "adguard";
                      url = "https://adguard.iatze.cc";
                      icon = "di:adguard-home";
                    }
                    {
                      title = "radarr";
                      url = "https://radarr.iatze.cc";
                      icon = "di:radarr";
                    }
                    {
                      title = "jellyseerr";
                      url = "https://jellyseerr.iatze.cc";
                      icon = "di:jellyseerr";
                    }
                    {
                      title = "kavita";
                      url = "https://kavita.iatze.cc";
                      icon = "di:kavita";
                    }
                    {
                      title = "freshrss";
                      url = "https://freshrss.iatze.cc";
                      icon = "di:freshrss";
                    }
                    {
                      title = "qbittorrent";
                      url = "https://qb.iatze.cc";
                      icon = "di:qbittorrent";
                    }
                    {
                      title = "linkwarden";
                      url = "https://lw.iatze.cc";
                      icon = "di:linkwarden.png";
                    }
                    {
                      title = "navidrome";
                      url = "https://music.iatze.cc";
                      icon = "di:navidrome";
                    }
                    {
                      title = "home-assistant";
                      url = "https://home.iatze.cc";
                      icon = "di:home-assistant";
                    }
                    {
                      title = "immich";
                      url = "https://photos.iatze.cc";
                      icon = "di:immich";
                    }
                    {
                      title = "sugoi";
                      url = "https://sugoi.iatze.cc";
                      icon = "https://sugoi.iatze.cc/assets/favicon.webp";
                    }
                  ];
                }
                {
                  type = "bookmarks";
                  style = "dynamic-columns-experimental";
                  groups = [
                    {
                      title = "Main";
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
                          title = "FotMob";
                          url = "https://fotmob.com";
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
                          title = "Bluesky";
                          url = "https://bsky.app";
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
                  type = "group";
                  widgets = let
                    shared-properties = {
                      collapse-after = 7;
                      limit = 10;
                      cache = "30m";
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
                  type = "twitch-channels";
                  channels = [
                    "theprimeagen"
                    "s0mcs"
                    "tarik"
                    "Ottomated"
                    "hyoon"
                    "zanderfps"
                    "tenz"
                    "xeppaa"
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
