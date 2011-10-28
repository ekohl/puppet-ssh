class ssh::nagios {
  $ssh_port = $ssh_port ? { '' => 22, default => $ssh_port }
  nagios::service{ "ssh_port_${ssh_port}": check_command => "ssh_port!$ssh_port" }
}
