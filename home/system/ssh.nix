{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "chibi" = {
        hostname = "100.87.38.99";
        identityFile = "~/.ssh/id_ed25519_servers";
      };
      "inari" = {
        hostname = "100.68.202.4";
        identityFile = "~/.ssh/id_ed25519_servers";
      };
      "git.iatze.cc" = {
        hostname = "100.87.38.99";
        identityFile = "~/.ssh/id_ed25519";
        port = 2222;
      };
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
