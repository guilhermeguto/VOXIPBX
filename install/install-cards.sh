#!/bin/bash

    clear
    echo " > Instalar PLACAS ToFalando"
    echo "====================================="
    echo "  1)  Instalar PLaca E1 - R2"
    echo "  2)  Instalar Placa E1 - ISDN "
    echo "  0)  Sair"
    echo -n "(0-7 : "
    read OPTION < /dev/tty

ExitFinish=0

while [ $ExitFinish -eq 0 ]; do


	 case $OPTION in

		1)
			clear
			cd /usr/src/

			# Instalando OpenR2
			if [ ! -d "/usr/src/dahdi" ]; then
			
                                read -p  "baixar o DAHDI"

				printf "Deseja instalar o DAHDI agora? (Y/n): "
				read INPT
			if [ "$INPT" = "n" ]; then 
				bash install-cards.sh
				echo ""
				exit
			fi


				clear
                        	cd /usr/src/
				rm -rf asterisk* dahdi* libpri*
                        	wget -c http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-2.9.0+2.9.0.1.tar.gz
                        	wget -c http://downloads.asterisk.org/pub/telephony/libpri/libpri-1.4-current.tar.gz
                        	wget -c http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-1.8.26.1.tar.gz


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
			
                        	#Instaldo LIBPRI
                        	cd /usr/src
                        	tar xvfz libpri-1.4-current.tar.gz
                        	ln -s libpri-1.4.14 libpri

				#Instalando ASTERISK
                        	cd /usr/src/
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
				/etc/init.d/dahdi restart
				/etc/ini.d/asterisk restart

				/var/www/ipbx/install/install-cards.sh
				ExitFinish=1
			else

                                wget -c https://openr2.googlecode.com/files/openr2-1.3.3.tar.gz
                                tar xvfz openr2-1.3.3.tar.gz
                                ln -s openr2-1.3.3 openr2
				cd openr2
				./configure --prefix=/usr
				make
				make install
				/etc/init.d/dahdi restart
                                /etc/ini.d/asterisk restart
                                /var/www/ipbx/install/install-cards.sh
                                ExitFinish=1
			fi

                ;;


		0)
        		clear
			bash install-asterisk.sh
			ExitFinish=1
		;;
		*)
	esac
done

