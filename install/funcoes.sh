#!/bin/bash

func_variaveis () {

echo "`ip addr show eth0 | cut -c16-32 | egrep \"[0-9a-z]{2}[:][0-9a-z]{2}[:][0-9a-z]{2}[:][0-9a-z]{2}[:][0-9a-z]{2}[:][0-9a-z]{2}$\"`" | tr -d ' : ' >/tmp/mac.txt
MAC=$(cat /tmp/mac.txt)
ALEATORIO=$MAC
TOFALANDO="ToFalando-$ALEATORIO"
TOFALANDO2="$ALEATORIO"
echo " $TOFALANDO"
echo "$TOFALANDO2"
export TOFALANDO=$TOFALANDO
export TOFALANDO2=$TOFALANDO2	
	
}


func_cpu () {



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

	
}


func_vpn () {


			cd /var/www/ipbx/install/etc/

		func_variaveis


			ssh root@vpn.tofalando.com.br '/usr/src/gera-key.sh '$TOFALANDO''
			scp root@vpn.tofalando.com.br:/etc/openvpn/easy-rsa/keys/$TOFALANDO* .

			sed -i s/"cert ipbx.crt"/"cert "$TOFALANDO".crt"/g /etc/openvpn/client.conf
			sed -i s/"key ipbx.key"/"key "$TOFALANDO".key"/g /etc/openvpn/client.conf

			mv ToFalando* /etc/openvpn/
			/etc/init.d/openvpn restart

}


func_host () {
	
		func_variaveis	

			echo "$TOFALANDO" > /etc/hostname

			echo "127.0.0.1	localhost" > /etc/hosts
			IP_LOCAL=$(/sbin/ifconfig | sed -n '2 p' | awk '{print $3}')
			echo "${IP_LOCAL}	$TOFALANDO.tofalando.net	$TOFALANDO" >> /etc/hosts

			echo "

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters" >> /etc/hosts

}


func_install_dahdi ()  { 

				clear
                        	cd /usr/src/
				rm -rf dahdi*
                        	wget -c http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-2.9.0+2.9.0.1.tar.gz
                        	
                        	# Instalando DAHDI
                        	tar xvfz dahdi-linux-complete-2.9.0+2.9.0.1.tar.gz
                        	ln -s dahdi-linux-complete-2.9.0+2.9.0.1/ dahdi
				cd dahdi
				
				# Complinado o OSLEC
				cd /usr/src
				KERNEL=$(uname -r | cut -d '.' -f1,2)
				echo "$KERNEL"
				wget -c ftp://ftp.kernel.org/pub/linux/kernel/v3.x/linux-$KERNEL.tar.bz2
				tar xvfj linux-$KERNEL.tar.bz2 -C /usr/src/
				ln -s linux-$KERNEL linux
				cd /usr/src/dahdi/linux/drivers/staging
				rm -rf echo
				mkdir /usr/src/dahdi/linux/drivers/staging
				mkdir /usr/src/dahdi/linux/drivers/staging/echo
				cp -fR /usr/src/linux/drivers/staging/echo /usr/src/dahdi/linux/drivers/staging
				sed -i "s|#obj-m += dahdi_echocan_oslec.o|obj-m += dahdi_echocan_oslec.o|" /usr/src/dahdi/linux/drivers/dahdi/Kbuild
				sed -i "s|#obj-m += ../staging/echo/|obj-m += ../staging/echo/|" /usr/src/dahdi/linux/drivers/dahdi/Kbuild
				echo 'obj-m += echo.o' > /usr/src/dahdi/linux/drivers/staging/echo/Kbuild
				cd /usr/src/dahdi/
				make all
				make install
				make config
				ExitFinish=1
 }
 
 func_install_dahdi_2 ()  { 

				clear
                        	cd /usr/src/
				
                        	# Instalando DAHDI
				cd dahdi
				
				# Complinado o OSLEC
				cd /usr/src
				KERNEL=$(uname -r | cut -d '.' -f1,2)
				echo "$KERNEL"
				wget -c ftp://ftp.kernel.org/pub/linux/kernel/v3.x/linux-$KERNEL.tar.bz2
				tar xvfj linux-$KERNEL.tar.bz2 -C /usr/src/
				ln -s linux-$KERNEL linux
				cd /usr/src/dahdi/linux/drivers/staging
				rm -rf echo
				mkdir /usr/src/dahdi/linux/drivers/staging
				mkdir /usr/src/dahdi/linux/drivers/staging/echo
				cp -fR /usr/src/linux/drivers/staging/echo /usr/src/dahdi/linux/drivers/staging
				sed -i "s|#obj-m += dahdi_echocan_oslec.o|obj-m += dahdi_echocan_oslec.o|" /usr/src/dahdi/linux/drivers/dahdi/Kbuild
				sed -i "s|#obj-m += ../staging/echo/|obj-m += ../staging/echo/|" /usr/src/dahdi/linux/drivers/dahdi/Kbuild
				echo 'obj-m += echo.o' > /usr/src/dahdi/linux/drivers/staging/echo/Kbuild
				cd /usr/src/dahdi/
				make all
				make install
				make config
				ExitFinish=1
 }
 

func_install_asterisk () { 

				#Instalando ASTERISK
				clear
				rm -rf asterisk*
                	        cd /usr/src/
                	        wget -c http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-1.8.26.1.tar.gz
                        	tar zxvf asterisk-1.8.26.1.tar.gz
                        	ln -s asterisk-1.8.26.1 asterisk
                        	cd asterisk
                        	make distclean
                        	./configure
                        	contrib/scripts/get_mp3_source.sh
                        	make menuselect.makeopts
                        	menuselect/menuselect --disable CORE-SOUNDS-EN-GSM --enable app_mysql --enable cdr_mysql --enable res_config_mysql --enable cdr_odbc --enable res_odbc --enable res_config_odbc --enable  format_mp3 --enable cdr_csv menuselect.makeopts
                        	make
                        	make install
                        	make config
                        	make samples
                        	ldconfig
                        	cd ..
                        	/etc/init.d/asterisk restart
                        	echo done
                        	ExitFinish=1
                        

}

func_libpri () { 

                        	clear
                        	cd /usr/src/
				rm -rf libpri*
                        	wget -c http://downloads.asterisk.org/pub/telephony/libpri/libpri-1.4-current.tar.gz


                        	#Instaldo LIBPRI
                        	cd /usr/src
                        	tar xvfz libpri-1.4-current.tar.gz
                        	ln -s libpri-1.4.14 libpri
                        	cd libpri
                        	make
                        	make install
                        	cd ..
                        	ExitFinish=1
                       



}


func_install_openr2 () { 


                                cd /usr/src/
                                rm -rf openr2*
                                wget -c https://openr2.googlecode.com/files/openr2-1.3.3.tar.gz
                                tar xvfz openr2-1.3.3.tar.gz
                                ln -s openr2-1.3.3 openr2
				cd openr2
				./configure --prefix=/usr
				make
				make install
				/etc/init.d/dahdi restart
				#bash install-cards.sh
                                ExitFinish=1

}

func_install_g729 () { 


# Checar asterisk



				cpu=`getconf LONG_BIT`
		if echo $cpu | grep -i "32" > /dev/null ; then
				echo "32"
				cd /usr/src/
				cd /usr/lib/asterisk/modules/
				wget -c http://asterisk.hosting.lv/bin/codec_g729-ast18-gcc4-glibc-pentium.so
				mv codec_g729-ast18-gcc4-glibc-pentium.so codec_g729.so
				chmod 755 /usr/lib/asterisk/modules/codec_g729.so
				asterisk -x "core restart now"
				ExitFinish=1
		else
				echo "64"
				cd /usr/src/
				cd /usr/lib/asterisk/modules/
				wget -c http://asterisk.hosting.lv/bin/codec_g729-ast18-icc-glibc-x86_64-pentium4.so
				mv codec_g729-ast18-icc-glibc-x86_64-pentium4.so codec_g729.so
				chmod 755 /usr/lib/asterisk/modules/codec_g729.so
				asterisk -x "core restart now"
				ExitFinish=1

		fi

	
}

func_install_mesa () {

				cpu=`getconf LONG_BIT`
		if echo $cpu | grep -i "32" > /dev/null ; then
				echo "32"

				clear
				cd /var/www/ipbx/
				cd /usr/src
        			wget -c http://download2.fop2.com/fop2-2.27-debian-i386.tgz
        			tar zxvf fop2-2.27-debian-i386.tgz
        			cd fop2
        			make install
        			cd /var/www/ipbx/install/mesa
        			cp fop2.cfg /usr/local/fop2/
        			cp buttons.cfg /usr/local/fop2/
        			cp presence.js /var/www/fop2/js/
        			cp config.php /var/www/fop2/
        			cp lang_pt_BR.js /var/www/fop2/js/
				rm -rf /etc/asterisk/manager.conf
				cp manager.conf /etc/asterisk
				cd /var/www/ipbx/
				ln -s /var/www/fop2/ mesa
				cd /usr/src
        			rm -rf fop*
        			echo "create database fop2" | mysql -u root -ptofalando2014
				/etc/init.d/fop2 restart
        
				# Alterações em Arquivos
				sed -i s/";callevents=no"/callevents=yes/g /etc/asterisk/sip.conf
				/etc/init.d/asterisk restart
				clear
				ExitFinish=1


		else
				echo "64"
				clear
				cd /var/www/ipbx/
				cd /usr/src
				wget -c http://download2.fop2.com/fop2-2.27-debian-x86_64.tgz
				tar zxvf fop2-2.27-debian-x86_64.tgz
				cd fop2
				make install
				cd /var/www/ipbx/install/mesa
				cp fop2.cfg /usr/local/fop2/
				cp buttons.cfg /usr/local/fop2/
				cp presence.js /var/www/fop2/js/
				cp config.php /var/www/fop2/
				cp lang_pt_BR.js /var/www/fop2/js/
				rm -rf /etc/asterisk/manager.conf
				cp manager.conf /etc/asterisk/
				cd /var/www/ipbx/
        			ln -s /var/www/fop2/ mesa
				cd /usr/src
				rm -rf fop*
				echo "create database fop2" | mysql -u root -ptofalando2014
				/etc/init.d/fop2 restart

				# Alterações em Arquivos
        			sed -i s/";callevents=no"/callevents=yes/g /etc/asterisk/sip.conf
        			/etc/init.d/asterisk restart
				clear
				ExitFinish=1

		fi



}
