class zabbix::proxy inherits zabbix {
    $zabbix_proxy_conf = "$zabbix_config_dir/zabbix_proxy.conf"

    package {
        "zabbix-proxy":
            ensure	=> installed,
			require	=> Yumrepo['itsc'];
		'fping':
			ensure	=> installed,
			require	=> Yumrepo['epel'];
    }

	mysql::db { 'zabbix':
		user		=> 'zabbix',
		password	=> "${zabbix_proxy_db_pass}",
		host		=> 'localhost',
		grant		=> ['all'],
  		charset   	=> 'utf8',
	}

	exec{ 'initialize_proxy_db':
		command		=> "mysql -u root zabbix < /usr/share/zabbix/mysql.sql",
		refreshonly	=> true,
      	unless		=> "mysql -u root -B -s -r -e \"SELECT EXISTS(SELECT * FROM zabbix.history)\"",
      	path      	=> '/usr/local/sbin:/usr/bin',
		require		=> Database['zabbix'],
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
			before		=> Exec['initialize_proxy_db'],
            require 	=> [ Package["zabbix-proxy"], File["$zabbix_proxy_conf"], Database['zabbix'] ];
    }
	
}

