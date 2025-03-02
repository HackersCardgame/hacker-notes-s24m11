#!/bin/bash

#Script Template
#==============================================================================
#title           :
#description     :
#author		 :Marc Landolt, Twitter: @PinkyDef / Github: @braindef
#date            :
#version         :0.1
#usage		 :
#notes           :
#bash_version    :
#==============================================================================


# Define Editor
#==============================================================================
#EDITOR=$(which nano)
EDITOR=$(which vim)
#==============================================================================


# Color Definitions
#==============================================================================
red="\e[91m"
yellow="\e[0;33m"
green="\e[0;32m"
default="\e[39m"
#==============================================================================


# Define which Linux Distribution
#==============================================================================
#distro=jessie
#distro=stretch
#distro=buster
distro=bullseye
#==============================================================================

# Define ipv4 for Apt
ip="-o Acquire::ForceIPv4=true"

# Helper Function to show first the command that is beeing executed
#==============================================================================
function ShowAndExecute {
#show command
echo ================================================================================
echo -e "🟡 ${yellow} $1 ${default}"
#echo --------------------------------------------------------------------------------

#execute command

if [[ "$1" == *"-y"* ]]
then
  sudo $1 >/dev/null
else
  sudo $1
fi

#test if it worked or give an ERROR Message in red, return code of apt is stored in $?
rc=$?;
if [[ $rc != 0 ]]
  then
          echo -e "🔴 ${red} $1 ${default}"
          echo -e ${red}ERROR${default} $rc
	  echo $1 >>fail.txt
  else
  echo -e "🟢 ${green} $1 ${default}"
fi
}
##test if everything worked
#==============================================================================


# Helper Function for YES or NO Answers
#------------------------------------------------------------------------------
# Example YESNO "Question to ask" "command to be executed"
#==============================================================================
function YESNO {
echo -e -n "
${red}$1 [y/N]${default} "
read -d'' -s -n1 answer
echo
if  [ "$answer" = "y" ] || [ "$answer" = "Y" ]
then
return 0
else
echo -e "
"
return 1
fi
}
#==============================================================================


# Test if script runs as root otherweise exit with exit code 1
#==============================================================================
#if [[ $EUID -ne 0 ]]; then
#  echo -e -n "
#${red}You must be a root user to run this script${default}
#at the moment you are " 2>&1
#  id | cut -d " " -f1
#  echo
#  exit 1
#fi
#==============================================================================


# Test if user has given enough parameters
#==============================================================================
if "$1" = ""
then
echo -e "
Usage:
------
Enter the (new) Database Password as parameter ${red}sudo ${0} 123456${default} "
echo
echo " arguments ---------------->  ${@}     "
echo " \$1 ----------------------->  $1       "
echo " \$2 ----------------------->  $2       "
echo " path to script ----------->  ${0}     "
echo " parent path -------------->  ${0%/*}  "
echo " script name -------------->  ${0##*/} "
echo
exit 0
fi
#==============================================================================

echo -e "${red}${0} ${@}${default}"

# get the newest updates
#==============================================================================
ShowAndExecute "cat -e /var/lib/dpkg/lock"

ShowAndExecute "apt --fix-broken $ip install"

ShowAndExecute "dpkg --configure -a"

ShowAndExecute "apt-get -y $ip update"

ShowAndExecute "apt-get -y $ip upgrade"

ShowAndExecute "apt-get -y $ip dist-upgrade"

ShowAndExecute "apt-get -y $ip install sudo git vim nano"
#==============================================================================

# edit repository list
#==============================================================================
if YESNO "Edit /etc/apt/sources.list?"
then
ShowAndExecute "$EDITOR /etc/apt/sources.list"
fi


# edit repository list
#==============================================================================
if YESNO "add pamblue or pamusb"
then
ShowAndExecute "apt-get -y libpam-blue"
vim /etc/pam.d/common-auth
echo "
  general {
   # the normal timeout for scanning
   # watch out for a tiny timeslot for scanning
   # values ​​between 3 and 15 seconds are valid
   timeout = 3;
 }
 # configuration for user korzendorfer
 korzendorfer = {
  
     # bluetooth device name
     name = tux;
  
     # bluetooth mac address
     bluemac = 54: 34: 34: 34: 34: 34;
     # a seaparate timeout
     timeout = 10;
 }
" >> /etc/security/bluesscan.conf
vim /etc/security/bluesscan.conf
#TODO: add sudo for echo and vim
#TODO: revive libusb for poor children
fi

if YESNO "Use TOR (The Onion Router) for APT Transport? (only debian, needs sudo)"
then
  cp /etc/apt/sources.list /etc/apt/sources.list.$(date +%y%m%d%H%m%s)

  ShowAndExecute "apt-get -y $ip install torsocks apt-transport-tor"

  cp /etc/apt/sources.list /etc/apt/sources.list-$(date +%Y%m%d-%H%M%S.bak)
  echo "
deb tor+http://vwakviie2ienjx6t.onion/debian/ $distro main contrib
deb tor+http://earthqfvaeuv5bla.onion/debian/ $distro main contrib
" > /etc/apt/sources.list

ShowAndExecute "apt-get -y update"

ShowAndExecute "apt-get -y upgrade"

ShowAndExecute "apt-get -y $ip install tor tor-arm"
fi

if YESNO "Use normal httpredir.debian.org for APT Transport?"
then
  cp /etc/apt/sources.list /etc/apt/sources.list-$(date +%Y%m%d-%H%M%S.bak)
  echo "
deb http://httpredir.debian.org/debian/ $distro main contrib
deb-src http://httpredir.debian.org/debian/ $distro main contrib
deb http://security.debian.org/ $distro/updates main contrib
deb-src http://security.debian.org/ $distro/updates main contrib
deb http://httpredir.debian.org/debian/ $distro-updates main contrib
deb-src http://httpredir.debian.org/debian/ $distro-updates main contrib
" >/etc/apt/sources.list

fi

# edit repository list after modification
#==============================================================================
if YESNO "Edit /etc/apt/sources.list?"
then
ShowAndExecute "$EDITOR /etc/apt/sources.list"
ShowAndExecute "apt-get -y update"
ShowAndExecute "apt-get -y upgrade"
fi

if YESNO "install r8168-dkms?"
then
  ShowAndExecute "apt-get install r8168-dkms"
fi

# edit repository list after modification
#==============================================================================

ShowAndExecute "apt-get -y $ip install keepassx"
ShowAndExecute "apt-get -y $ip install build-essential linux-headers-$(uname -r)"
ShowAndExecute "apt-get -y $ip install md5deep"
ShowAndExecute "apt-get -y $ip install mixxx"
ShowAndExecute "apt-get -y $ip install rdfind"
ShowAndExecute "apt-get -y $ip install xdg-utils"
ShowAndExecute "apt-get -y $ip install nmap"
ShowAndExecute "apt-get -y $ip install rsync"
ShowAndExecute "apt-get -y $ip install snmp"
ShowAndExecute "apt-get -y $ip install jigdo-file"
ShowAndExecute "apt-get -y $ip install build-essential"
ShowAndExecute "apt-get -y $ip install pkg-config "
ShowAndExecute "apt-get -y $ip install libdbus-1-dev"
ShowAndExecute "apt-get -y $ip install apt-file"
ShowAndExecute "apt-file  $ip update"
ShowAndExecute "apt-get -y $ip install figlet"
ShowAndExecute "apt-get -y $ip install git"
ShowAndExecute "apt-get -y $ip install tcpdump"
ShowAndExecute "apt-get -y $ip install iptraf"
ShowAndExecute "apt-get -y $ip install gparted"
#ShowAndExecute "apt-get -y $ip install lightdm lxde"
ShowAndExecute "apt-get -y $ip install gdm3 gnome gnome-shell"
ShowAndExecute "apt-get -y $ip install gconf-editor"
ShowAndExecute "apt-get -y $ip install chromium"
ShowAndExecute "apt-get -y $ip install chromium-browser"
ShowAndExecute "apt-get -y $ip install inkscape"
ShowAndExecute "apt-get -y $ip install gimp"
ShowAndExecute "apt-get -y $ip install libreoffice"
ShowAndExecute "apt-get -y $ip install libreoffice-help-de"
ShowAndExecute "apt-get -y $ip install libreoffice-l10n-de"
ShowAndExecute "apt-get -y $ip install cups-pdf"
ShowAndExecute "apt-get -y $ip install icedove"
ShowAndExecute "apt-get -y $ip install thunderbird"
ShowAndExecute "apt-get -y $ip install vlc"
ShowAndExecute "apt-get -y $ip install valkyrie"
ShowAndExecute "apt-get -y $ip install valgrind"
ShowAndExecute "apt-get -y $ip install blender"
ShowAndExecute "apt-get -y $ip install qrencode"
ShowAndExecute "apt-get -y $ip install calibre"
ShowAndExecute "apt-get -y $ip install tor"
ShowAndExecute "apt-get -y $ip install nyx"
ShowAndExecute "apt-get -y $ip install whois"
ShowAndExecute "apt-get -y $ip install bind9-dnsutils"
ShowAndExecute "apt-get -y $ip install aeskulap"
ShowAndExecute "apt-get -y $ip install abcde" #Rip Audio CD Console

#video Editing
ShowAndExecute "apt-get -y $ip install kdenlive"
#display typed keys
ShowAndExecute "apt-get -y $ip install screenkey"

ShowAndExecute "apt-get -y $ip install simplescreenrecorder"
#ShowAndExecute "apt-get -y $ip install virtualbox"

#music software
ShowAndExecute "apt-get -y $ip install audacity"
ShowAndExecute "apt-get -y $ip install mixxx"
ShowAndExecute "apt-get -y $ip install lmms"
ShowAndExecute "apt-get -y install gnome-boxes"

ShowAndExecute "apt-get -y $ip install posterazor"
ShowAndExecute "apt-get -y $ip install gconf-editor"
ShowAndExecute "apt-get -y $ip install mumble"
ShowAndExecute "apt-get -y $ip install font-manager"
ShowAndExecute "apt-get -y $ip install quassel "
#ShowAndExecute "apt-get -y $ip install pidgin"
#ShowAndExecute "apt-get -y $ip install checksecurity"
ShowAndExecute "apt-get -y $ip install spyder"
ShowAndExecute "apt-get -y $ip install spyder3"
ShowAndExecute "apt-get -y install espeak-ng"
ShowAndExecute "apt-get -y install speech-dispatcher"
ShowAndExecute "apt-get -y install speech-dispatcher-espeak-ng"
#ShowAndExecute "apt-get -y install mbrola-de1"
#ShowAndExecute "apt-get -y install mbrola-en1"
#ShowAndExecute "apt-get -y install mbrola"

ShowAndExecute "apt-get -y install xournalpp"
ShowAndExecute "apt-get -y install ocrmypdf"
// ocrmypdf -l eng secretSociety-image.pdf secretSociety.pdf

ShowAndExecute "apt-get -y install gimagereader-gtk"
ShowAndExecute "apt-get -y install gimagereader"
ShowAndExecute "apt-get -y install tesseract-ocr-eng"
ShowAndExecute "apt-get -y install tesseract-ocr-deu"
# https://stackoverflow.com/questions/68604202/imagemagick-cache-resource-exhausted
#/etc/ImageMagick-6/policy.xml
#<policy domain="resource" name="memory" value="2GiB"/>
#<policy domain="resource" name="map" value="2GiB"/>
#convert -density 300 -compress jpeg $(ls -v *.png) dennett.pdf

ShowAndExecute "apt-get -y $ip install gnome-disk-utility"

ShowAndExecute "apt-get -y $ip install whois"

#kali like environment
#ShowAndExecute "apt-get -y $ip install forensics-all"


#streaming software
ShowAndExecute "apt-get -y $ip install obs-studio"

ShowAndExecute "apt-get -y purge youtube-dl"
ShowAndExecute "apt-get -y install python3-pip"
ShowAndExecute "apt-get -y install python3-full"
ShowAndExecute "pip install youtube-dl"
ShowAndExecute "pip3 install music-dl"
ShowAndExecute "pip install yt-dlp"
ShowAndExecute "pip3 install pip_search"

ShowAndExecute "pip install youtube-dl -U"
ShowAndExecute "pip3 install music-dl -U"
ShowAndExecute "pip install yt-dlp -U"
ShowAndExecute "pip3 install pip_search -U"
ShowAndExecute "apt-get install pipx"

ShowAndExecute "apt-get install neochat"


ShowAndExecute "apt-get $ip install arp-scan"
ShowAndExecute "apt-get $ip install sshfs"
ShowAndExecute "apt-get $ip install wine64"

if YESNO "add-architecture i386?"
then
  ShowAndExecute "dpkg --add-architecture i386"
fi

ShowAndExecute "apt-get purge firefox-esr"

ShowAndExecute "apt-get update"
ShowAndExecute "apt-get $ip install wine32"

ShowAndExecute "apt-get $ip install wine"

ShowAndExecute "apt-get $ip install qjackctl"

ShowAndExecute "apt-get $ip install jackd"

#ShowAndExecute "apt-get $ip install guitarix"


ShowAndExecute "apt-get autoremove"

#Network Discovery
for i in $(echo 0 1 2 179 180 192)
do
  echo -e ${red}scanning 192.168.$i.0/24${default}
  echo ========================
  sudo arp-scan 192.168.$i.0/24 #--interface enp1s0f1 
done


#change theme of ubuntu to more debian like theme
sudo update-alternatives --config gdm3.css

#always show the complete path in nautilus and eternal gnome-Screencast (CTRL-ALT-SHIFT R)
sudo -u $(logname) gsettings set org.gnome.nautilus.preferences always-use-location-entry true
sudo -u $(logname) gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 0

ShowAndExecute "apt remove gnome-shell-extension-ubuntu-dock"
# ShowAndExecute "apt-get $ip install chrome-gnome-shell"

# nice colored man pages
if grep -q LESS_TERMCAP "~/.bashrc"
then echo "~/.bashrc already modified"
else
echo "
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
" >>~/.bashrc
fi

ShowAndExecute "sudo apt install vanilla-gnome-desktop"

gsettings set org.gnome.nautilus.preferences always-use-location-entry true
gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 0

echo "add the following line to /etc/fstab
sshfs#marcland@ftp.marclandolt.ch:/ /mnt/hostpoint
"

echo "
export HISTTIMEFORMAT='%F %T ' ">> ~/.bashrc


gsettings set org.gnome.shell disable-user-extensions true

if YESNO "block twitter and facebook?"
then

  ShowAndExecute "sudo apt-get install dnsmasq"
  ShowAndExecute "sudo apt-get install resolvconf"

  ShowAndExecute "sudo systemctl start resolvconf.service"
  ShowAndExecute "sudo systemctl enable resolvconf.service"
  ShowAndExecute "sudo systemctl status resolvconf.service"

  sudo bash -c '
  echo "
nameserver 127.0.0.1
nameserver 192.168.1.1
" > /etc/resolvconf/resolv.conf.d/head
'

  sudo bash -c '
  echo "
listen-address=127.0.0.1
address=/twitter.com/127.0.0.1
address=/facebook.com/127.0.0.1
" > /etc/dnsmasq.conf '

  ShowAndExecute "sudo systemctl restart dnsmasq.service"
  ShowAndExecute "sudo systemctl start resolvconf.service"
  ShowAndExecute "sudo systemctl enable resolvconf.service"
  ShowAndExecute "sudo systemctl status resolvconf.service"
fi

#sudo -u $(logname) bash -c '/usr/bin/keepassx'
