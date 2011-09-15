#$zabbix_mysql_user_parameters = []

class zabbix::mysql inherits zabbix::agent {

	file {
		"$zabbix_userparameter_config_dir/userparameter_mysql.conf":
			content	=> template("zabbix/userparameter_mysql_conf.erb"),
			group   => "zabbix",
			owner 	=> "zabbix",
			mode  	=> "600",
			require => Package["zabbix-agent"];

		"$zabbix_user_home_dir/.my.cnf":
			source 	=> "puppet:///modules/zabbix/my.cnf",
			group   => "zabbix",
			owner 	=> "zabbix",
			mode  	=> "600",
        	require	=> [ Package["zabbix-agent"], File["$zabbix_user_home_dir"] ];
	}

}
