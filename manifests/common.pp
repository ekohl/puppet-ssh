class ssh::common {
  file {
    "/etc/ssh":
      ensure => directory,
      mode => 0755, owner => root, group => root,
  }
}

