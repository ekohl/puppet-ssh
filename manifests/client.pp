class ssh::client inherits ssh::common {
  package {
    "openssh-client":
      name => "${ssh::client::params::packagename}",
      ensure => installed,
      require => File["/etc/ssh"],
  }

  file {
    "/etc/ssh/ssh_known_hosts":
      mode => 0644, owner => root, group => 0;
  }

  # Now collect all server keys
  Sshkey <<||>>
}
