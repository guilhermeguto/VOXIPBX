#!/bin/bash

cd /usr/src/

a2enmod rewrite
/etc/init.d/apache2 restart

git clone https://github.com/eluizbr/VOXIPBX.git
mv VOXIPBX ipbx
mv ipbx  /var/www/
cd /var/www/
chown -R www-data.www-data *
chmod 755 ipbx
ln -s ipbx snep
ln -s ipbx snep2
chmod -R 755 *
cd /etc/apache2/sites-enabled/
cp /var/www/ipbx/install/tofalando.apache2 001-tofalando
cd /etc/apache2/sites-available/
cp /var/www/ipbx/install/tofalando.apache1 default
cd /var/log
mkdir snep
touch snep/ui.log
touch snep/agi.log
chown -R www-data.www-data snep/
cd /var/lib/asterisk/agi-bin/
chmod 776 /var/www/snep/agi -R
 ln -s /var/www/snep/agi/ snep
cd /etc
cp -avr /var/www/snep/install/etc/* .
mv /var/spool/asterisk/monitor /var/spool/asterisk/monitor.snep
ln -sf /var/www/snep/arquivos /var/spool/asterisk/monitor
cd /var/lib/asterisk
mkdir moh/tmp moh/backup
mkdir -p moh/snep_1/tmp moh/snep_1/backup
mkdir -p moh/snep_2/tmp moh/snep_2/backup
mkdir -p moh/snep_3/tmp moh/snep_3/backup
chown www-data.www-data /var/lib/asterisk/moh/ -R
cd /usr/src
wget -c http://www.sneplivre.com.br/downloads/asterisk-sounds.tgz
tar -xvzf asterisk-sounds.tgz -C /var/lib/asterisk/
mkdir -p /var/lib/asterisk/sounds/pt_BR/tmp
mkdir -p /var/lib/asterisk/sounds/tmp
mkdir -p /var/lib/asterisk/sounds/pt_BR/backup
mkdir -p /var/lib/asterisk/sounds/backup
chown www-data:www-data /var/lib/asterisk/sounds -R
cd /var/www/snep/sounds/
ln -sf /var/lib/asterisk/moh/ moh
ln -sf /var/lib/asterisk/sounds/pt_BR/ pt_BR

cd /var/www/snep/install/
mysql -uroot -ptofalando2014 < database.sql
cd /var/www/snep/modules/default/installer
mysql -uroot -ptofalando2014 snep25 < schema.sql
mysql -uroot -ptofalando2014 snep25 < system_data.sql
mysql -uroot -ptofalando2014 snep25 < cnl_data.sql

# Seta a CPU

cpu=`getconf LONG_BIT`

if echo $cpu | grep -i "32" > /dev/null ; then
	echo "32"
	cd /usr/lib/odbc/
       	ln -s /usr/lib/i386-linux-gnu/odbc/libmyodbc.so

else
	echo "64"

	cd /usr/lib/odbc/
        ln -s /usr/lib/x86_64-linux-gnu/odbc/libmyodbc.so

fi

# Fim seta CPU


sed -i s/"register_argc_argv = Off"/register_argc_argv=On/g /etc/php5/cli/php.ini
sed -i s/"register_argc_argv = Off"/register_argc_argv=On/g /etc/php5/cgi/php.ini
sed -i s/"register_argc_argv = Off"/register_argc_argv=On/g /etc/php5/apache2/php.ini

rm -rf /var/www/index.html
cd /var/www/ipbx/install
cp index.php /var/www/
echo "tofalando" > /etc/hostname

#POSTIFX
cd /var/www/ipbx/install/etc/
cp -rfv postfix /etc/
cd /usr/src/


# Seta IPTABLES

iptables -I INPUT 3 -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT

service iptables save

/etc/init.d/mysql restart
/etc/init.d/apache2 restart
/etc/init.d/asterisk start
/etc/init.d/postfix restart

bash install-asterisk.sh
