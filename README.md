# getcve
Get all CVEs mentioned in Ubuntu package chagelog

Copy getcve.sh to zabbix external scripts directory and add this line to
/etc/zabbix/zabbix\_agentd.conf.
```
UserParameter=get\_cve, bash /etc/zabbix/externalscripts/getcve.sh
```
