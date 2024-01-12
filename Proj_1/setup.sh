#!/bin/bash

#####################
### Proj_1 Script ###
#####################

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Installs tools
sudo apt update
sudo apt install -y members net-tools vim sl expect

#Create a File System on /dev/sd{b,c}
sudo mkfs.ext4 /dev/sdb
sudo mkfs.ext4 /dev/sdc

# Changing the mount point of /var/www to /dev/sdb
sudo mkdir /mnt/tmp
sudo mount /dev/sdb /mnt/tmp
sudo rsync -avx /var/www/* /mnt/tmp/
sudo umount /mnt/tmp
sudo mount /dev/sdb /var/www

# Aquire the UUID for /dev/sdb
result=$(sudo blkid -o value -s UUID "/dev/sdb")

# Print the UUID to check if it's obtained correctly
echo "UUID: $result"

# Define the line to check for in fstab
desired_line1="UUID=$result  /var/www ext4  defaults  0 2"

# Check if the line already exists in the fstab file
if grep -Fxq "$desired_line1" /etc/fstab; then
  echo "The line is already present in /etc/fstab."
else
  # Add the line to fstab using echo and append (>>) operator
  echo "$desired_line1" | sudo tee -a /etc/fstab > /dev/null
  echo "The line has been added to /etc/fstab."
fi

# Changing the mount point of /backups to /dev/sdc
sudo mkdir -p /backups/web-servers
sudo mount /dev/sdb /backups

# Aquire the UUID for /dev/sdc
result=$(sudo blkid -o value -s UUID "/dev/sdc")

# Print the UUID to check if it's obtained correctly
echo "UUID: $result"

# Define the line to check for in fstab
desired_line1="UUID=$result  /backups ext4  defaults  0 2"

# Check if the line already exists in the fstab file
if grep -Fxq "$desired_line1" /etc/fstab; then
  echo "The line is already present in /etc/fstab."
else
  # Add the line to fstab using echo and append (>>) operator
  echo "$desired_line1" | sudo tee -a /etc/fstab > /dev/null
  echo "The line has been added to /etc/fstab."
fi

# Creating users
user_credentials=(
    "ceditor:changeme"
    "webdev1:changeme"
    "testusr:changeme"
)

# Loop through the usernames and passwords and create each user
for user_cred in "${user_credentials[@]}"; do
    username=$(echo "$user_cred" | cut -d':' -f1)
    password=$(echo "$user_cred" | cut -d':' -f2)

    # Use expect to interact and provide the password
    expect -c "
        spawn sudo adduser --gecos "" $username
        expect \"New password:\"
        send \"$password\r\"
        expect \"Retype new password:\"
        send \"$password\r\"
        interact
    "
done

# Creating Groups and assigning users
sudo groupadd developers
sudo groupadd editors
sudo groupadd allstaff
sudo usermod -aG developers webdev1
sudo usermod -aG editors ceditor
sudo usermod -aG allstaff webdev1,ceditor,testusr


# Creating directories and movinf .conf and .html files
sudo mkdir -p /var/www/boofblasters/{history,staff}
sudo scp /etc/scripts/Proj_1/boofblasters_index.html /var/www/boofblasters/boofblasters_index.html
sudo scp /etc/scripts/Proj_1/boofblasters_hist_index.html /var/www/boofblasters/history/boofblasters_hist_index.html
sudo scp /etc/scripts/Proj_1/boofblasters_staff_index.html /var/www/boofblasters/staff/boofblasters_staff_index.html
sudo scp /etc/scripts/Proj_1/boofblasters.conf /etc/apache2/sites-available/boofblasters.conf
sudo ln -s /etc/apache2/sites-available/boofblasters.conf /etc/apache2/sites-enabled/boofblasters.conf

# Changing permissions
sudo chown -R root:developers /etc/apache2/
sudo chown -R root:editors /var/www/
sudo chmod -R 771 /etc/apache2/
sudo chmod -R 771 /var/www/
