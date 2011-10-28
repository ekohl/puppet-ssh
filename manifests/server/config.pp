define ssh::server::config($value) {
  augeas {
    "sshd_config_$name":
      context =>  "/files/etc/ssh/sshd_config",
      changes =>  "set $name $value",
      onlyif  =>  "get $name != $value",
      # onlyif  =>  "match $name/*[.='$value'] size == 0",
  }
}
