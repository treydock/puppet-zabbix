class zabbix::agent inherits zabbix::base {
	$zabbix_userparameter_config_dir = "/etc/zabbix/zabbix_agentd"
    $zabbix_agentd_conf = "$zabbix_config_dir/zabbix_agentd.conf"

    package {
        "zabbix-agent":
            ensure	=> installed,
			require	=> Yumrepo['itsc']
    }

    file {
        $zabbix_userparameter_config_dir:
            ensure 	=> directory,
            owner 	=> root,
            group 	=> root,
            mode 	=> 755,
            require => [ Package["zabbix-agent"], File["$zabbix_config_dir"] ];

        $zabbix_agentd_conf:
            owner 	=> root,
            group 	=> root,
            mode 	=> 644,
            content => template("zabbix/zabbix_agentd_conf.erb"),
            require => [ Package["zabbix-agent"], File["$zabbix_config_dir"] ];
	}

    service {
        "zabbix_agentd":
            enable 		=> true,
            ensure 		=> running,
			hasstatus	=> false,
			hasrestart	=> true,
            require 	=> [ Package["zabbix-agent"], File["$zabbix_config_dir"], File["$zabbix_log_dir"], File["$zabbix_pid_dir"] ];
    }
	
}

