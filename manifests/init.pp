# ssh/manifests/init.pp - common ssh related components
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.
# Adapted by Alexander Werner <alex@documentfoundation.org>

class ssh::common {
  file {
    "/etc/ssh":
      ensure => directory,
      mode => 0755, owner => root, group => root,
  }
}

class ssh::client inherits ssh::common {
  package {
    "openssh-client":
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

class ssh::server inherits ssh::client {
  
  package {
    "openssh-server":
      ensure => installed,
      require => File["/etc/ssh"],
  }
  
  service {
    ssh:
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
  
  nagios::service{ "ssh_port_${ssh_port}": check_command => "ssh_port!$ssh_port" }
  
}

define ssh::server::config($value) {
  augeas {
    "sshd_config_$name":
      context =>  "/files/etc/ssh/sshd_config",
      changes =>  "set $name $value",
      onlyif  =>  "get $name != $value",
      # onlyif  =>  "match $name/*[.='$value'] size == 0",
  }
}
