#!/bin/bash



cd /var/www/ipbx/install/phpagi
cp -rfv * /var/lib/asterisk/agi-bin/
cd /var/www/ipbx/install/
cp consulta_op.php /var/lib/asterisk/agi-bin/
cd /var/www/ipbx/install/
cat extensions.conf > /etc/asterisk/extensions.conf
cat snep-sip.conf >> /etc/asterisk/sip.conf

/etc/init.d/apache2 restart
/etc/init.d/asterisk restart
