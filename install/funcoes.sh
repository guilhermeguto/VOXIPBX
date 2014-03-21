#!/bin/bash
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
				cd /var/www/ipbx/
				git pull origin $BRANCH
				cd /usr/lib/asterisk/modules/
				wget -c http://asterisk.hosting.lv/bin/codec_g729-ast18-gcc4-glibc-pentium.so
				mv codec_g729-ast18-gcc4-glibc-pentium.so codec_g729.so
				chmod 755 /usr/lib/asterisk/modules/codec_g729.so
				asterisk -x "core restart now"
		else
				echo "64"
				cd /var/www/ipbx/
				git pull origin $BRANCH

				cd /usr/lib/asterisk/modules/
				wget -c http://asterisk.hosting.lv/bin/codec_g729-ast18-icc-glibc-x86_64-pentium4.so
				mv codec_g729-ast18-icc-glibc-x86_64-pentium4.so codec_g729.so
				chmod 755 /usr/lib/asterisk/modules/codec_g729.so
				asterisk -x "core restart now"

		fi

	
}
