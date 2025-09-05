{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = true;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
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
