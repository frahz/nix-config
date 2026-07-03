{
  config,
  osConfig,
  ...
}:
let

  graphical = osConfig.casa.profiles.graphical;
in
{
  xdg = {
    inherit (graphical) enable;
    mime.enable = graphical.enable;
    mimeApps = {
      inherit (graphical) enable;
      defaultApplications = {
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        "x-scheme-handler/spotify" = [ "spotify.desktop" ];
        "x-scheme-handler/discord" = [ "vesktop.desktop" ];
      };
    };
  };

  home.sessionVariables = {
    CODEX_HOME = "${config.xdg.configHome}/codex";
    # Node.js configuration
    # https://nodejs.org/api/repl.html#environment-variable-options
    NODE_REPL_HISTORY = "${config.xdg.stateHome}/node_repl_history";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/config";
  };

  xdg.configFile = {
    "npm/npmrc".text = ''
      prefix=${config.xdg.dataHome}/npm
      cache=${config.xdg.cacheHome}/npm
      init-module=${config.xdg.configHome}/npm/config/npm-init.js
    '';
    "wget/wgetrc".text = ''
      hsts-file = ${config.xdg.dataHome}/wget/hsts
    '';
  };
}
