_: {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        hide_env_diff = true;
      };
    };
  };
  home.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
  };
}
