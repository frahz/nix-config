{
  config,
  ...
}:
let
  home = config.users.users.frahz.home;
in
{
  hjem.users.frahz.environment.sessionVariables = {
    CARGO_HOME = "${home}/.local/share/cargo";
    CODEX_HOME = "${home}/.config/codex";
    GNUPGHOME = "${home}/.local/share/gnupg";
    GOMODCACHE = "${home}/.cache/go/pkg/mod";
    GOPATH = "${home}/.local/share/go";
    NODE_REPL_HISTORY = "${home}/.local/state/node_repl_history";
    NPM_CONFIG_CACHE = "${home}/.cache/npm";
    NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
    NPM_CONFIG_USERCONFIG = "${home}/.config/npm/config";
    RUSTUP_HOME = "${home}/.local/share/rustup";

    # Important
    EDITOR = "nvim";
    TERMINAL = "ghostty";
    VISUAL = "nvim";
  };

  hjem.users.frahz.xdg = {
    cache.directory = "${home}/.cache";
    config.directory = "${home}/.config";
    data.directory = "${home}/.local/share";
    state.directory = "${home}/.local/state";
  };
}
