{
  config,
  pkgs,
  ...
}: let
  inherit (config.programs) git;
in {
  programs.jujutsu = {
    inherit (git) enable;

    settings = {
      user = {
        name = git.userName;
        email = git.userEmail;
      };

      aliases = {
        tug = [
          "bookmark"
          "move"
          "--from"
          "heads(::@- & bookmarks())"
          "--to"
          "@-"
        ];
        ll = ["log" "-r" "::"];
      };

      ui = {
        default-command = "status";
        pager = "${pkgs.delta}/bin/delta";
      };

      template-aliases = {
        "format_short_id(id)" = "id.shortest()";
      };
    };
  };
}
