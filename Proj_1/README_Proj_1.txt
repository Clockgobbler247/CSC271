Project #1 Web Server

Materials Needed:
ISO file of the latest version of Mint
ISO file of any other Linux distro
VirtualBox software
Internet connection

PART 1: Creating the VM
1.)	Open VirtualBox. Click the “Machine” tab in the upper left corner of the window, and select New…
2.)	Create a name for the VM, select the ISO image that you want. Leave the rest as default and click Next.
3.)	Create a username and password. Here you can also change the hostname of the VM on this screen. Make sure the “Guest Additions” box is selected. Click Next
4.)	Select a base memory and number of processors. Make sure to increase the processor count to 2 or higher. Click Next
5.)	Keep the default radial button selected and choose the disk size you want. Click Next
6.)	Review your VM settings and click finished when you are comfortable with them. 
7.)	The machine should start to boot up automatically. Mint will load into a temporary desktop before fully installing the OS.
8.)	Click on the “Install Linux Mint” CD icon on the desktop.
9.)	Walk through installation steps, accepting all defaults.
10.)	When the machine prompts for a reboot, reboot the machine. 
11.)	Repeat steps 1-6 with any other linux flavor you’re comfortable with, so you have two working VMs.

Part 3: Networking
1.)	In VirtualBox with the machines powered down, right click the Mint VM and go to settings. Navigate to Network. 
2.)	Under the first adapter tab, use the drop down menu to select “Host-only Adapter”. On the second tab, select the “Enable Network Adapter” button and select "NAT” from the drop-down menu.
3.)	Hit OK
4.)	Repeat steps 1-3 on your other VM.


PART 2: Adding additional disks.
1.)	Locate your powered off VM in the list of VMs and right-click on it. Select Settings and navigate to Storage.
2.)	Highlight Controller: SATA and click Adds hard disk.
3.)	 This opens the Hard Disk Selector window.
4.)	Click Create in the top left corner of the window.
5.)	The wizard for VHD creation will open. Select the VDI radial button and hit next. Click next on the storage page.
6.)	Keep the default location and adjust the size of the VDI to what suits your needs and click finish.
7.)	The newly created disk should be highlighted automatically but should be named [computer name] _1.vdi. Select the drive you just created and click choose. Now you should have two disks located under the Controller:SATA section. Click OK
8.)	Repeat steps 1 through 7 for a 3rd disk used for backups.
9.)	Power on the machine
***At this point, both VMs need to be powered on and logged in***
Part 3: Github
1.)	On your Mint server, open a terminal and switch users to root
sudo su

2.)	Make a scripts directory in /etc and change directories using the following:
mkdir /etc/scripts

cd /etc/scripts

3.)	Install git with:
apt install -y git

4.)	Clone the repo made for this project using the following:
git clone https://github.com/Clockgobbler247/CSC271.git

5.)	Make the scripts executable.
cd CSC271/Proj_1/ && chmod +x *.sh

6.)	Run the script.
./setup.sh
Part 4: Creating backup jobs.
1.)	Setup a backup schedule with cron jobs on the Mint server.
sudo crontab -e


2.)	Add the following lines:
0 5 * * 1 /etc/scripts/CSC271/Proj_1/backup.sh
0 5 * * 0,2-6 /etc/scripts/CSC271/Proj_1/diff_backup.sh
30 5 * * 0 sudo mv /backups/web-server/full_backup/new/* /backups/web-server/full_backup/old/
5 5 15,30 * * sudo rm -rf /backups/web-server/full_backup/old/*
0 0 * * * /usr/bin/find /backups/web-server/diff_backup -name "*" -type f -mtime +15 -exec rm -f {} \;

Part 5: Modifying the /etc/hosts file 
1.)	Verify the IP address of the Mint server. The first entry should be the internal IP address.
hostname -I or ifconfig 


2.)	On the other VM, edit the /etc/hosts file and add the following entries:
sudo vim /etc/hosts

[Mint IP address]	boofblasters.com
[Mint IP address]	boofblasters.com/staff
[Mint IP address]	boofblasters.com/history

The /etc/hosts file on the Mint server is modified similarly, but has the loopback address in place of the IP.


3.)	Open Firefox and navigate to boofblasters.com.

End of Project
