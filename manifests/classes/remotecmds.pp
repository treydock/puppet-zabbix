class zabbix::remotecmds inherits zabbix::agent {

/* This allows zabbix to start the puppet service if it is down */
    sudo::directive { "zabbix-puppet":
        ensure  => present,
        content => "zabbix ALL=NOPASSWD: /var/lib/zabbix/bin/start_puppet",
       # source  => "puppet:///modules/zabbix/zabbix_sudocmd",
    }   

    file {
        "$zabbix_user_home_dir/bin":
            ensure  => directory,
            owner   => zabbix,
            group   => zabbix,
            mode    => 700,
            require => [ User["zabbix"], File["$zabbix_user_home_dir"] ];

        "$zabbix_user_home_dir/bin/start_puppet":
            ensure  => present,
            owner   => zabbix,
            group   => zabbix,
            mode    => 770,
            require => [ Class['zabbix::agent'], File["$zabbix_user_home_dir/bin"] ];
    }

/* End puppet specific remote command */


}
