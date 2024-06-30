_: {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host chibi
          Hostname 100.87.38.99
          User frahz
          IdentityFile ~/.ssh/id_ed25519_servers

      Host inari
          Hostname 100.68.202.4
          User frahz
          IdentityFile ~/.ssh/id_ed25519_servers

      Host git.iatze.cc
          Hostname 100.68.202.4
          IdentityFile ~/.ssh/id_ed25519
          Port 2221

      Host github.com
          Hostname github.com
          IdentityFile ~/.ssh/id_ed25519
    '';
  };
}
