class zabbix::proxy inherits zabbix {
    $zabbix_proxy_conf = "$zabbix_config_dir/zabbix_proxy.conf"

    package {
        "zabbix-proxy":
            ensure	=> installed,
			require	=> Yumrepo['itsc']
    }

	mysql::db { 'zabbix':
		user		=> 'zabbix',
		password	=> "${zabbix_proxy_db_pass}",
		host		=> 'localhost',
		grant		=> ['all'],
  		charset   	=> 'utf8',
	}

    file {
        $zabbix_proxy_conf:
            owner 	=> 'root',
            group 	=> 'zabbix',
            mode 	=> 640,
            content => template("zabbix/zabbix_proxy_conf.erb"),
			notify	=> Service['zabbix_proxy'],
            require => [ Package["zabbix-proxy"] ];
	}

    service {
        "zabbix_proxy":
            enable 		=> true,
            ensure 		=> running,
			hasstatus	=> true,
			hasrestart	=> true,
            require 	=> [ Package["zabbix-proxy"], File["$zabbix_proxy_conf"] ];
    }
	
}

