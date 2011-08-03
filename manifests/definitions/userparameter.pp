define zabbix::userparameter (
	$ensure=present,
  	$content="",
  	$source="",
	$user_params=false

) {

	include zabbix::params

	file {"${zabbix::params::zabbix_userparameter_config_dir}/${name}.conf":
      	ensure  => $ensure,
		group   => "zabbix",
		owner 	=> "zabbix",
		mode  	=> "600",
      	content => $content ? {
        	""      => undef,   
        	default => $content,
      	},
      	source  => $source ? {
       		""      => undef,  
        	default => $source,
      	},
      	require => File["${zabbix::params::zabbix_userparameter_config_dir}"],
    }
}
