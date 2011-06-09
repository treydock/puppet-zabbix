= Zabbix Puppet module =

== Installation ==

Place this in your Puppet installation's module directory

Rename files/my.cnf.example to files/my.cnf
Update the password line in files/my.cnf to reflect your zabbix user's mysql password


== Usage ==

To add the agent to a node:

include zabbix::agent

To add mysql zabbix checks to node:

include zabbix::mysql


