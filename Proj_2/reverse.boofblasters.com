;
; BIND reverse data file for the internal 10.0.0.0/24 boofblaster.com network
;
$TTL 86400
@  IN  SOA  boofblasters.com. root.boofblasters.com. (
         2      ;Serial
         3600   ;Refresh
         1800   ;Retry
         604800 ;Expire
         86400  ;Minimum TTL
)
;Your Name Server Info
@  IN  NS  DNS.boofblasters.com.
DNS  IN  A  10.0.0.7
;Reverse Lookup for Your DNS Server
7 IN PTR DNS.boofblasters.com.
;PTR Record IP address to HostName
4  IN  PTR  Ubuntu-GUI.boofblasters.com.
3  IN  PTR  www.boofblasters.com
