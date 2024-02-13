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
