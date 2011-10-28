class ssh::client::params {
  $packagename = $operatingsystem ? {
    /Debian|Ubuntu/ => "openssh-client",
    /CentOS|rhel/   => "openssh-clients",
    default         => "openssh",
  }
}
