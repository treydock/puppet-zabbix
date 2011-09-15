class zabbix::remotecmds inherits zabbix::agent {

/* This allows zabbix to start the puppet service if it is down */

/* This sudo portion relies on https://github.com/treydock/puppet-sudo, if you have another means
	to add this sudo directive, I would recommend that

The file zabbix_sudocmd contains this line...

zabbix ALL=NOPASSWD: /var/lib/zabbix/bin/start_puppet

    sudo::directive { "zabbix-puppet":
        ensure  => present,
        source  => "puppet:///modules/zabbix/zabbix_sudocmd",
    }   
*/

    file {
        "$zabbix_user_home_dir/bin":
            ensure  => directory,
            owner   => zabbix,
            group   => zabbix,
            mode    => 700,
            require => [ User["zabbix"], File["$zabbix_user_home_dir"] ];

        "$zabbix_user_home_dir/bin/start_puppet":
            ensure  => present,
			source	=> 'puppet:///modules/zabbix/start_puppet',
            owner   => zabbix,
            group   => zabbix,
            mode    => 770,
            require => [ Class['zabbix::agent'], File["$zabbix_user_home_dir/bin"] ];
    }

/* End puppet specific remote command */

}
