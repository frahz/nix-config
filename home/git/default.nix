{...}:

{
    programs.git = {
        enable = true;
        userName = "frahz";
        userEmail = "me@frahz.dev";

        delta = {
            enable = true;
            options = {
                navigate = true;
                light = false;
                line-numbers = true;
            };
        };

        extraConfig = {
            core = {
                editor = "nvim";
            };
            merge.conflictstyle = "diff3";
            diff.colorMoved = "default";
        };
    };
}
