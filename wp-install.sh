#!/bin/bash
#### Script Auto Install Wordpress
#### IqbalFAF
##### Warna

cyan='\e[0;36m'
green='\e[0;34m'
okegreen='\033[92m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
yellow='\e[0;33m'
BlueF='\e[1;34m' #Biru
RESET="\033[00m" #normal
orange='\e[38;5;166m'
#### IPKU
IPKU=$(wget -qO- ipv4.icanhazip.com);

clear
echo -e $okegreen "       __      __                .___                                        "
echo"       /  \    /  \___________  __| _/____________   ____   ______ ______    "
echo"       \   \/\/   /  _ \_  __ \/ __ |\____ \_  __ \_/ __ \ /  ___//  ___/    "
echo"        \        (  <_> )  | \/ /_/ ||  |_> >  | \/\  ___/ \___ \ \___ \     "
echo"         \__/\  / \____/|__|  \____ ||   __/|__|    \___  >____  >____  >    "
echo"              \/                   \/|__|               \/     \/     \/     "

echo -e $BlueF "Auto Install Wordpress Debian & Ubuntu"
echo ""
echo "Password Database Nya:"
read -p "Password baru: " -e -i IqbalGanteng DatabasePass
echo ""
echo "Nama Untuk Database Nya"
echo "Jangan Gunakan Karakter Selain _"
read -p "Nama Database: " -e -i Wordpress DatabaseName
echo ""
echo "Oke, Sekarang Waktunya Instalasi"
read -n1 -r -p "Tekan sembarang tombol untuk melanjutkan..."

#apt-get update
apt-get update -y
apt-get install build-essential expect -y

apt-get install -y mysql-server

#mysql_secure_installation
so1=$(expect -c "
spawn mysql_secure_installation; sleep 3
expect \"\";  sleep 3; send \"\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect eof; ")
echo "$so1"
#\r
#Y
#pass
#pass
#Y
#Y
#Y
#Y

chown -R mysql:mysql /var/lib/mysql/
chmod -R 755 /var/lib/mysql/

apt-get install -y nginx php7.0 php7.0-fpm php7.0-cli php7.0-mysql php7.0-mcrypt
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
curl https://raw.githubusercontent.com/iqbalfaf/WP-AutoInstall/nginx.conf > /etc/nginx/nginx.conf
curl https://raw.githubusercontent.com/iqbalfaf/WP-AutoInstall/wordpress.conf > /etc/nginx/conf.d/wordpress.conf
sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf

useradd -m vps
mkdir -p /home/vps/public_html
chown -R www-data:www-data /home/vps/public_html
chmod -R g+rw /home/vps/public_html
service php7.0-fpm restart
service nginx restart

#### Download Script Wordpress
cd /home/vps/public_html
wget https://wordpress.org/latest.zip
unzip latest.zip


#mysql -u root -p
so2=$(expect -c "
spawn mysql -u root -p; sleep 3
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"CREATE DATABASE IF NOT EXISTS $DatabaseName;EXIT;\r\"
expect eof; ")
echo "$so2"
#pass
#CREATE DATABASE IF NOT EXISTS OCS_PANEL;EXIT;

clear
echo "Sekarang Buka Browser Akses Server Nya $IPKU Dan Ini Data Buat Database Nya"
echo "Database:"
echo "- Database Host: localhost"
echo "- Database Name: $DatabaseName"
echo "- Database User: root"
echo "- Database Pass: $DatabasePass"

sleep 3
echo ""
read -p "Kalau Sudah, silahkan Tekan tombol [Enter] untuk melanjutkan..."
echo ""
cd /root
wget -O webrestart https://github.com/iqbalfaf/WP-AutoInstall/webrestart.sh
mv webrestart /usr/bin/
chmod +x /usr/bin/webrestart

apt-get -y --force-yes -f install libxml-parser-perl

rm -R /home/vps/public_html/latest.zip

cd
rm -f /root/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile
read -p " Instalasi Wordpress Selesai"
echo ""
# info
clear
echo "=======================================================" 
echo "Wordpress Auto Install IqbalFAF" 
echo ""
echo "Untuk Restart Web Server Ketik webrestart" 
echo "Semoga Happy :)"
echo "=======================================================" 
cd ~/

