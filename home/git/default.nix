{
  config,
  pkgs,
  ...
}: let
  path = "delta/themes/mocha.gitconfig";
in {
  xdg.configFile = {
    ${path}.source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/delta/main/themes/mocha.gitconfig";
      hash = "sha256-I2sD5TEYjnvvms5JWFEM/wW+4V3ofTOwaRBhdQko0CM=";
    };
  };

  programs.git = {
    enable = true;
    userName = "frahz";
    userEmail = "me@frahz.dev";

    includes = [
      {
        path = "${config.xdg.configHome}/${path}";
      }
    ];

    delta = {
      enable = true;
      options = {
        features = "catppuccin-mocha";
        navigate = true;
        light = false;
        line-numbers = true;
      };
    };

    extraConfig = {
      core = {
        editor = "nvim";
      };
      merge.conflictstyle = "zdiff3";
      diff.colorMoved = "default";
      init.defaultBranch = "main";
    };
  };
}
