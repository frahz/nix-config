{
  hjem.users.frahz.files.".ssh/config".text = ''
    Host *
      ForwardAgent no
      AddKeysToAgent no
      Compression no
      ServerAliveInterval 0
      ServerAliveCountMax 3
      HashKnownHosts yes
      UserKnownHostsFile ~/.ssh/known_hosts
      ControlMaster no
      ControlPath ~/.ssh/master-%r@%n:%p
      ControlPersist no

    Host chibi
      HostName 100.87.38.99
      IdentityFile ~/.ssh/id_ed25519_servers

    Host inari
      HostName 100.68.202.4
      IdentityFile ~/.ssh/id_ed25519_servers

    Host shintaku
      HostName 141.148.191.92
      IdentityFile ~/.ssh/id_ed25519_servers

    Host git.iatze.cc
      HostName 100.87.38.99
      IdentityFile ~/.ssh/id_ed25519

    Host github.com
      HostName github.com
      IdentityFile ~/.ssh/id_ed25519
  '';
}
