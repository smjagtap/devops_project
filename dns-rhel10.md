## DNS Server Configuration with BIND on RHEL 10 for OpenShift

This guide provides a complete step-by-step for setting up a local DNS server using BIND on RHEL 10. 
The configuration is intended for lab environments  allowing internal name resolution like api.linuxsecret.lab.local and *.apps.linuxsecret.lab.local.

### 1. Install required packages.
~~~
sudo dnf install bind bind-utils -y
~~~

### 2. Edit the main BIND configuration file

~~~
sudo vim /etc/named.conf
~~~

Modify or add the following directives:

~~~
listen-on port 53 { any; };
allow-query     { any; };
recursion yes;
~~~

Add DNS zones at the end of the file:

~~~
zone "linuxsecret.lab.local" IN {
    type master;
    file "/var/named/linuxsecret.lab.local.db";
    allow-update { none; };
};

zone "122.168.192.in-addr.arpa" IN {
    type master;
    file "/var/named/192.168.122.rev";
    allow-update { none; };
};
~~~

### 3. Create zone files

#### Forward zone (linuxsecret.lab.local):
~~~
cat /var/named/linuxsecret.lab.local.db 
$TTL 1D
@       IN SOA  dns.linuxsecret.lab.local. root.linuxsecret.lab.local. (
                            2025071702 ; Serial
                            1D         ; Refresh
                            1H         ; Retry
                            1W         ; Expire
                            3H )       ; Minimum

        IN NS   dns.linuxsecret.lab.local.

dns     IN A    192.168.122.115
rhel97  IN A    192.168.122.189
apps    IN A    192.168.122.200
*.apps  IN A    192.168.122.200

~~~

#### Reverse zone (192.168.122.rev):

~~~
 cat /var/named/192.168.122.rev 
$TTL 1D
@       IN SOA  dns.linuxsecret.lab.local. root.linuxsecret.lab.local. (
                            2025071702
                            1D
                            1H
                            1W
                            3H )
        IN NS   dns.linuxsecret.lab.local.

115     IN PTR  dns.linuxsecret.lab.local.
189     IN PTR  rhel97.linuxsecret.lab.local.
200     IN PTR  apps.linuxsecret.lab.local.
~~~

### 4. Adjust permissions and SELinux context

~~~~
sudo chown root:named /var/named/*.db
sudo restorecon -v /var/named/*.db
~~~~

### 5. Start and enable the BIND service

~~~
sudo systemctl enable --now named
systemctl status named
~~~

### 6. Open DNS port in the firewall
~~~
sudo firewall-cmd --add-service=dns --permanent
sudo firewall-cmd --reload
~~~

### 7. Test DNS resolution

~~~
Forward lookup:

#dig @localhost api.linuxsecret.lab.local

Reverse lookup:

#dig -x 192.168.10.100 @localhost
~~~

### 8. Configure clients to use this DNS
Edit /etc/resolv.conf:
~~~
nameserver 192.168.10.10
search linuxsecret.lab.local
~~~

To make it permanent with NetworkManager:

~~~
#nmcli con mod <connection-name> ipv4.dns "192.168.122.10"
#nmcli con mod <connection-name> ipv4.ignore-auto-dns yes
#nmcli con up <connection-name>
~~~

### Check logs with:

~~~
#journalctl -u named
~~~

### Validate the zone files:

~~~
#named-checkzone linuxsecret.lab.local /var/named/linuxsecret.lab.local.db
#named-checkzone 122.168.192.in-addr.arpa /var/named/192.168.122.rev
~~~


## Named failed 

~~~
# systemctl status named
× named.service - Berkeley Internet Name Domain (DNS)
     Loaded: loaded (/usr/lib/systemd/system/named.service; enabled; preset: disabled)
     Active: failed (Result: exit-code) since Fri 2026-02-27 23:54:30 IST; 4min 36s ago
 Invocation: 9183e4e2c42a4746b001dbce805ed4c0
    Process: 3541 ExecStartPre=/bin/bash -c if [ ! "$DISABLE_ZONE_CHECKING" == "yes" ]; then /usr/bin/named-checkconf -z "$NA>
   Mem peak: 2.8M
        CPU: 11ms

Feb 27 23:54:30 dns.linuxsecret.lab.local systemd[1]: Starting named.service - Berkeley Internet Name Domain (DNS)...
Feb 27 23:54:30 dns.linuxsecret.lab.local bash[3542]: /usr/bin/named-checkconf: symbol lookup error: /lib64/libisc-9.18.33.so>
Feb 27 23:54:30 dns.linuxsecret.lab.local systemd[1]: named.service: Control process exited, code=exited, status=127/n/a
Feb 27 23:54:30 dns.linuxsecret.lab.local systemd[1]: named.service: Failed with result 'exit-code'.
Feb 27 23:54:30 dns.linuxsecret.lab.local systemd[1]: Failed to start named.service - Berkeley Internet Name Domain (DNS).
~~~

### Solution:

The openssl package was old version .

~~~
root@dns:~# openssl version
OpenSSL 3.2.2 4 Jun 2024 (Library: OpenSSL 3.2.2 4 Jun 2024)
~~~

~~~
root@dns:~# yum update openssl
Updating Subscription Management repositories.
Last metadata expiration check: 0:05:03 ago on Sat 28 Feb 2026 12:00:42 AM IST.
Dependencies resolved.
==============================================================================================================================
 Package                        Architecture Version                               Repository                            Size
==============================================================================================================================
Upgrading:
 crypto-policies                noarch       20250905-2.gitc7eb7b2.el10_1.1        rhel-10-for-x86_64-baseos-rpms        98 k
 crypto-policies-scripts        noarch       20250905-2.gitc7eb7b2.el10_1.1        rhel-10-for-x86_64-baseos-rpms       131 k
 openssl                        x86_64       1:3.5.1-7.el10_1                      rhel-10-for-x86_64-baseos-rpms       1.3 M
 openssl-fips-provider          x86_64       3.0.7-8.el10                          rhel-10-for-x86_64-baseos-rpms       9.2 k
 openssl-fips-provider-so       x86_64       3.0.7-8.el10                          rhel-10-for-x86_64-baseos-rpms       576 k
 openssl-libs                   x86_64       1:3.5.1-7.el10_1                      rhel-10-for-x86_64-baseos-rpms       2.3 M

Transaction Summary
~~~
~~~
root@dns:~# openssl version
OpenSSL 3.5.1 1 Jul 2025 (Library: OpenSSL 3.5.1 1 Jul 2025)
~~~
