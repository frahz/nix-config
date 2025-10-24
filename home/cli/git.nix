{
  programs = {
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        light = false;
        line-numbers = true;
      };
    };
    git = {
      enable = true;

      settings = {
        user = {
          name = "frahz";
          email = "me@frahz.dev";
        };
        core = {
          editor = "nvim";
        };
        merge.conflictstyle = "zdiff3";
        diff.colorMoved = "default";
        init.defaultBranch = "main";
      };
    };
  };

  catppuccin.delta.enable = true;
}
