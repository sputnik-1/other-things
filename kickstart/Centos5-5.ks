# An example kickstart file written for Centos 5.5
#
# The anaconda installer used with Centos does not like the %end tag, to end a section.
#
# Centos5-5.ks kickstart file.                                                        
                                                                                      
# Perform an installation from CD-ROM or DVD.
install                                                                               
cdrom                                                                                 
                                                                                      
# Centos 5.5 supports a Custom Partition Layout in text mode
text                                                                                  
                                                                                      
# Installation uses interactive mode.                                                 
# Use the information provided in the kickstart file during the                       
# installation, but allow for inspection and modification of the                      
# values given. You will be presented with each screen of the                         
# installation program with the values from the kickstart file.                       
# Either accept the values by clicking Next or change the values and                  
# click Next to continue.                                                             
interactive                                                                           
                                                                                      
# Select language.                                                                    
# lang en_US.UTF-8 works OK                                                           
lang en_GB.UTF-8                                                                      
                                                                                      
# Select keyboard.                                                                    
keyboard uk                                                                           
                                                                                      
# Select timezone.                                                                    
timezone --utc Europe/London                                                          
                                                                                      
# Configure static networking.                                                        
network --hostname=karsites --device eth0 --mtu=1500 --bootproto static --ip 10.10.10.10 
--netmask 255.255.255.0 --gateway 10.10.10.125 --nameserver 212.104.130.9,212.104.130.65
                                                                                      
# Reboot after installation.                                                          
reboot                                                                                
                                                                                      
# Start firewall.                                                                     
firewall --enabled --port=22:tcp                                                      
                                                                                      
# Authentication type - recommended defaults.                                         
authconfig --enableshadow --enablemd5                                                 
                                                                                      
# Turn off SELinux.                                                                   
selinux --disabled                                                                    
                                                                                      
# Don't install any bootloader - use the existing one.                                
bootloader --location=none                                                            
                                                                                      
#---------------------------------------------------                                  
                                                                                      
# Packages and groups to install.                                                     
%packages                                                                             

@british-support                                                                      
                                                                                      
# Install mc and legacy bitmap fonts.                                                 
mc                                                                                    
bitmap-fonts                                                                          
                                                                                      
@base                                                                                 
@core                                                                                 
keyutils                                                                              
trousers                                                                              
fipscheck                                                                             
device-mapper-multipath                                                               
libsane-hpaio                                                                         
                                                                                      
#---------------------------------------------------                                  
                                                                                      
# Packages and groups NOT to install.                                                 
-NetworkManager                                                                       
                                                                                      
# %end                                                                                
                                                                                      
#---------------------------------------------------                                  
                                                                                      
# Post installation script.                                                           
%post --interpreter /bin/bash --log=/root/Centos5-5.ks-log --erroronfail              
                                                                                      
# Backup suffix for original config files.                                            
ORG_SUFX=".cent5-5.org"                                                               
                                                                                      
#---------------------------------------------------                                  
                                                                                      
# Backup the faulty resolv.conf file.
cp -v /etc/resolv.conf /etc/resolv.conf$ORG_SUFX                                      
                                                                                      
# Delete the faulty resolv.conf file.                                                 
rm -fv /etc/resolv.conf                                                               
                                                                                      
# Create a working version of the resolv.conf file.                                   

COM1="# Eclipse ISP"                                                                  
DNS1="nameserver 212.104.130.9"                                                       
DNS2="nameserver 212.104.130.65"                                                      
                                                                                      
COM2="# OpenDNS"                                                                      
DNS3="nameserver 208.67.222.222"                                                      
DNS4="nameserver 208.67.220.220"                                                      
                                                                                      
FILE=${COM1}'\n'${DNS1}'\n'${DNS2}'\n''\n'${COM2}'\n'${DNS3}'\n'${DNS4}               
                                                                                      
echo -e $FILE                                                                         
                                                                                      
echo -e $FILE > resolv.conf                                                           
                                                                                      
cat resolv.conf                                                                       
                                                                                      
# Copy the new resolv.conf to /etc/resolv.conf                                        
cp -v resolv.conf /etc/resolv.conf                                                    
                                                                                      
# Make a backup copy                                                                  
cp -v resolv.conf /etc/resolv.conf.bak                                                
                                                                                      
cat /etc/resolv.conf                                                                  
                                                                                      
# # Setup the network.                                                                
# chkconfig --level 2345 network on                                                   
#                                                                                     
# # Stop the network.                                                                 
# /etc/init.d/network stop                                                            
#                                                                                     
# # Start the network.                                                                
# /etc/init.d/network start                                                           
#                                                                                     
# Ping remote host 10 times to test internet connection.                              
ping -c 10 www.grc.com                                                                
                                                                                      
echo                                                                                  
echo "\$ORG_SUFX is:"                                                                 
echo $ORG_SUFX                                                                        
echo                                                                                  
                                                                                      
# -------------------------------------------------- #                                
                                                                                      
# Set the font to 16 colors for mc to work OK.                                        
                                                                                      
# Backup the original i18n file.                                                      
cp -v /etc/sysconfig/i18n /etc/sysconfig/i18n$ORG_SUFX                                
                                                                                      
# Use sed to edit /etc/sysconfig/i18n file and replace                                
# SYSFONT="whatever" with SYSFONT="lat1-16".                                          
                                                                                      
sed -i s/SYSFONT=\".*\"/SYSFONT=\"lat1-16\"/ /etc/sysconfig/i18n                      
                                                                                      
# Set the font directly to make changes take effect immediately.                      
setfont lat1-16                                                                       
                                                                                      
# -------------------------------------------------- #
# EOF
# -------------------------------------------------- #
