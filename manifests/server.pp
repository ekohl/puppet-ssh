class ssh::server inherits ssh::client {
  package {
    "openssh-server":
      ensure => installed,
      require => File["/etc/ssh"],
  }

  service {
    "ssh":
      ensure => running,
      pattern => "sshd",
      require => Package["openssh-server"],
  }

  # Now add the key, if we've got one
  case $sshrsakey {
    "": {
      notice("no sshrsakey on $fqdn")
    }
    default: {
      @@sshkey { "$fqdn":
        type => ssh-rsa,
        key => $sshrsakey,
        ensure => present,
        require => Package["openssh-client"],
      }
    }
  }

  $ssh_port = $ssh_port ? { '' => 22, default => $ssh_port }
  $ssh_permit_root_login = $ssh_permit_root_login ? {'' => no, default => $ssh_permit_root_login}

  config{ "Port": value => $ssh_port }
  config{ "PermitRootLogin": value => $ssh_permit_root_login}
}

