
## Install FreeIPA packages

~~~
#dnf install freeipa-server freeipa-server-dns freeipa-client
~~~

## No dns ,no ntp
~~~
ipa-server-install  --domain linuxsecret.lab.local --realm LINUXSECRET.LAB.LOCAL --no-ntp --ds-password redhat@2026 --admin-password redhat@2026 --unattended
~~~

## with DNS
~~~
ipa-server-install  --domain linuxsecret.lab.local --realm LINUXSECRET.LAB.LOCAL --reverse-zone=122.168.192.in-addr.arpa --no-forwarders --no-ntp --setup-dns --ds-password P@ssw0rd@2026 --admin-password P@ssw0rd@2026 --unattended
~~~

## Completion message

~~~
Next steps:
	1. You must make sure these network ports are open:
		TCP Ports:
		  * 80, 443: HTTP/HTTPS
		  * 389, 636: LDAP/LDAPS
		  * 88, 464: kerberos
		  * 53: bind
		UDP Ports:
		  * 88, 464: kerberos
		  * 53: bind

	2. You can now obtain a kerberos ticket using the command: 'kinit admin'
	   This ticket will allow you to use the IPA tools (e.g., ipa user-add)
	   and the web user interface.

Be sure to back up the CA certificates stored in /root/cacert.p12
These files are required to create replicas. The password for these
files is the Directory Manager password
The ipa-server-install command was successful
~~~

## Allow services through Firewall

~~~
#firewall-cmd --add-service={dns,ntp,freeipa-ldap,freeipa-ldaps} --permanent
#firewall-cmd --permanent --add-port=80/tcp --add-port=443/tcp  --add-port=389/tcp --add-port=636/tcp --add-port=88/tcp --add-port=464/tcp --add-port=53/tcp --add-port=88/udp --add-port=464/udp --add-port=53/udp
#firewall-cmd --reload
~~~

Ref :  
[Session - 149 | FreeIPA Server & Client Configuration in Linux | FreeIPA With DNS | Nehra Classes](https://www.youtube.com/watch?v=XqSdP39CTgo&list=PL9LY4jTSNS214qn2rxcENE0YRWcHLWWUw&index=152)
