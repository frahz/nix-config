{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;

  cfg = config.casa.profiles.development;
  sources = config.catppuccin.sources;
  gitSettings = {
    core.editor = "nvim";
    credential = {
      "https://gist.github.com".helper = [
        ""
        "${lib.getExe pkgs.gh} auth git-credential"
      ];
      "https://github.com".helper = [
        ""
        "${lib.getExe pkgs.gh} auth git-credential"
      ];
    };
    delta = {
      features = "catppuccin-mocha";
      light = false;
      line-numbers = true;
      navigate = true;
    };
    diff.colorMoved = "default";
    include.path = "${sources.delta}/catppuccin.gitconfig";
    init.defaultBranch = "main";
    interactive.diffFilter = "${lib.getExe pkgs.delta} --color-only";
    merge.conflictstyle = "zdiff3";
    pager = {
      blame = lib.getExe pkgs.delta;
      diff = lib.getExe pkgs.delta;
      log = lib.getExe pkgs.delta;
      show = lib.getExe pkgs.delta;
    };
    user = {
      email = "me@frahz.dev";
      name = "frahz";
    };
  };
in
{
  config = lib.mkIf cfg.enable {
    hjem.users.frahz = {
      packages = builtins.attrValues {
        inherit (pkgs)
          gh
          git
          jujutsu
          delta
          tokei
          typst
          websocat

          # LSP /formatters
          bash-language-server
          gopls
          htmx-lsp
          libclang
          lua-language-server
          marksman
          nil
          nixfmt
          pyright
          rust-analyzer
          svelte-language-server
          tailwindcss-language-server
          tinymist
          typstyle
          typescript-language-server
          vscode-langservers-extracted
          ;
      };
      xdg.config.files = {
        "gh/config.yml" = {
          generator = (pkgs.formats.yaml { }).generate "gh-config.yml";
          value = {
            version = "1";
            git_protocol = "ssh";
            prompt = "enabled";
          };
        };
        "git/config" = {
          generator = lib.generators.toGitINI;
          value = gitSettings;
        };
        "jj/config.toml" = {
          generator = (pkgs.formats.toml { }).generate "jj-config.toml";
          value = {
            aliases = {
              l = singleton "log";
              ll = [
                "log"
                "-r"
                "::"
              ];
              tug = [
                "bookmark"
                "move"
                "--from"
                "heads(::@- & bookmarks())"
                "--to"
                "@-"
              ];
            };
            template-aliases = {
              "format_short_id(id)" = "id.shortest()";
              log_compact = ''
                if(root,
                  format_root_commit(self),
                  label(if(current_working_copy, "working_copy"),
                    concat(
                      separate(" ",
                        format_short_change_id_with_change_offset(self),
                        format_short_commit_id(self.commit_id()),
                        if(empty, label("empty", "(empty)")),
                        if(description,
                          description.first_line(),
                          label(if(empty, "empty"), description_placeholder),
                        ),
                        bookmarks,
                        tags,
                        working_copies,
                        if(conflict, label("conflict", "conflict")),
                        if(config("ui.show-cryptographic-signatures").as_boolean(),
                          format_short_cryptographic_signature(signature)),
                        if((!description || current_working_copy) && !empty, "\n" ++ diff.summary()),
                      ) ++ "\n",
                    ),
                  )
                )
              '';
            };
            ui = {
              default-command = [
                "log"
                "--template=log_compact"
              ];
              pager = lib.getExe pkgs.delta;
            };
            user = {
              email = "me@frahz.dev";
              name = "frahz";
            };
          };
        };
      };
    };
  };
}
