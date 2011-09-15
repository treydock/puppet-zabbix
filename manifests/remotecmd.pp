define zabbix::remotecmd (
	$ensure=present,
  	$content="",
  	$source="",
	$user_params=false

) {

	include zabbix::params

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
        "${zabbix::params::zabbix_user_home_dir}/bin":
            ensure  => directory,
            owner   => zabbix,
            group   => zabbix,
            mode    => 700,
            require => [ User["zabbix"], File["${zabbix::params::zabbix_user_home_dir}"] ];

        "${zabbix::params::zabbix_user_home_dir}/bin/${name}":
            ensure  => present,
            owner   => zabbix,
            group   => zabbix,
            mode    => 770,
	        content => $content ? { 
    	        ""      => undef,   
        	    default => $content,
        	},  
        	source  => $source ? { 
        	    ""      => undef,  
            	default => $source,
        	},  
            require => [ Class['zabbix::agent'], File["${zabbix::params::zabbix_user_home_dir}/bin"] ];
    }

}
