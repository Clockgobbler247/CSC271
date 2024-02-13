#!/bin/bash
#####################
### Proj_2 Script ###
#####################

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Creating users
sudo adduser --disabled-password --gecos "" dnseditor

expect << EOF
set NEW_PASSWORD "changeme"   ;# Replace with the desired new password
set USERNAME_LIST {dnseditor}

foreach username \$USERNAME_LIST {
    spawn passwd \$username
    expect "New password: "
    send "\$NEW_PASSWORD\r"
    expect "Retype new password: "
    send "\$NEW_PASSWORD\r"
    expect eof                    ;
}
EOF

# Creating directories and moving files
sudo mkdir -p /backups/dns-server/{full_backup,diff_backup}
sudo mkdir /backups/dns-server/full_backup/{new,old}
sudo cp -f /etc/scripts/CSC271/Proj_2/named.conf.options /etc/bind/named.conf.options
sudo cp -f /etc/scripts/CSC271/Proj_2/named.conf.local /etc/bind/named.conf.local
sudo cp -f /etc/scripts/CSC271/Proj_2/default.named /etc/default/named
sudo mv /etc/scripts/CSC271/Proj_2/forward.boofblasters.com /etc/bind/forward.boofblasters.com
sudo mv /etc/scripts/CSC271/Proj_2/reverse.boofblasters.com /etc/bind/reverse.boofblasters.com

# Start/Enable the named service and check configs
sudo systemctl start named && sudo systemctl enable named

if sudo named-checkconf /etc/bind/named.conf.local; then
  echo "Configuration file is OK."
else
  echo "Error: Configuration file syntax"
fi

if sudo named-checkzone boofblasters.com /etc/bind/forward.boofblasters.com; then
  echo "Forward zones are OK"
else
  echo "Forward zone syntax error"
fi

if sudo named-checkzone boofblasters.com /etc/bind/reverse.boofblasters.com; then
  echo "Reverse zones are OK"
else
  echo "Reverse zone syntax error"
fi
