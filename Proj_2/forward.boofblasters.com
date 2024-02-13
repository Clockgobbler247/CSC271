;
; BIND data file for internal 10.0.0.0/24 boofblasters.com network
;
$TTL  604800
@  IN  SOA  DNS.boofblasters.com. root.DNS.boofblasters.com. (
         2    ; Serial
         3600 ; Refresh
         1800 ; Retry
         604800 ; Expire
         604600 ) ; Negative Cache TTL
;Name Server Information
@  IN  NS  DNS.boofblasters.com.

;IP address of Your Domain Name Server(DNS)
DNS  IN  A  10.0.0.7
;A records for Hosts
@  IN  A  10.0.0.3
www  IN  A  10.0.0.3
apache-server  IN  A  10.0.0.3
Ubuntu-GUI  IN  A  10.0.0.4
