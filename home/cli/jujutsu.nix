{
  config,
  pkgs,
  ...
}:
let
  inherit (config.programs) git;
in
{
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
        l = [ "log" ];
        ll = [
          "log"
          "-r"
          "::"
        ];
      };

      ui = {
        default-command = [
          "log"
          "--template=log_compact"
        ];
        pager = "${pkgs.delta}/bin/delta";
      };

      template-aliases = {
        "format_short_id(id)" = "id.shortest()";
        "log_compact" = ''
          if(root,
            format_root_commit(self),
            label(if(current_working_copy, "working_copy"),
              concat(
                separate(" ",
                  format_short_change_id_with_hidden_and_divergent_info(self),
                  if(empty, label("empty", "(empty)")),
                  if(description,
                    description.first_line(),
                    label(if(empty, "empty"), description_placeholder),
                  ),
                  bookmarks,
                  tags,
                  working_copies,
                  if(git_head, label("git_head", "HEAD")),
                  if(conflict, label("conflict", "conflict")),
                  if(config("ui.show-cryptographic-signatures").as_boolean(),
                    format_short_cryptographic_signature(signature)),
                  if(!description && !empty, "\n" ++ diff.summary()),
                ) ++ "\n",
              ),
            )
          )
        '';
      };
    };
  };
}
