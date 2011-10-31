# Zabbix Puppet module #

## Requirements ##

The zabbix::puppet module relies on puppetlabs-mysql, see https://github.com/puppetlabs/puppetlabs-mysql

## Installation ##

Place this in your Puppet installation's module directory

Rename files/my.cnf.example to files/my.cnf
Update the password line in files/my.cnf to reflect your zabbix user's mysql password


## Usage - Zabbix Agent ##

1) Node must have $zabbix_server defined

```ruby
$zabbix_server 			= "zabbixserver.domain"
```

2) Add agent class to node

```ruby
include zabbix::agent
```

### Puppet specific remote command ###


To allow Zabbix to restart the puppet daemon, should it stop, do the following

```ruby
include zabbix::remotecmds
```

See manifests/classes/remotecmds.pp for more information

### Adding user paremeter checks ###

Additional user parameters can be added by use of a definition.  Below is an example of how to add a user parameter file to a node

```ruby
	zabbix::userparameter {
		'userparameter_mounted':
			ensure	=> present,
			source	=> 'puppet:///modules/zabbix/userparameter_mounted.conf';
	}			
```

I've included an example userparameter file '''files/userparameter_mounted.conf''' as an example

### Added mysql checks to node ###

The mysql class inherits agent.

The checks in templates/userparameter_mysql_conf.erb are examples that are packaged with Zabbix

Additional checks can be added in the node definition.  This example adds a check for mediawiki user count

```ruby
    $zabbix_mysql_user_parameters =  {
        item1 => { 'name' => 'mediawiki.usercount[*]', 'command' => 'mysql -B -s -e "SELECT count(*) FROM user" $1'},
    }   

include zabbix::mysql

```

## Usage - Zabbix Proxy ##

1) Node must have $zabbix_server and $zabbix_proxy_db_pass defined

```ruby
$zabbix_server 			= "zabbixserver.domain"
$zabbix_proxy_db_pass 	= "password"
```

2) Add agent class to node

```ruby
include zabbix::proxy
```

