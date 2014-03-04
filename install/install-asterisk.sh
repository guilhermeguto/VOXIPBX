#!/bin/bash

    clear
    echo " > Instalando Asterisk"
    echo "====================================="
    echo "  1)  Instalar Asterisk - DAHDI - LIBPRI"
    echo "  2)  Instalar Asterisk apenas"
    echo "  3)  Instalar PABX ToFalando"
    echo "  4)  Instalar Portabilidade"
    echo "  5)  Instalar G729 FREE"
    echo "  0)  Sair"
    echo -n "(0-5 : "
    read OPTION < /dev/tty

ExitFinish=0

while [ $ExitFinish -eq 0 ]; do


	 case $OPTION in

		1)
			clear
			cd /usr/src/
			wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz
			wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-1.4-current.tar.gz
			wget -c http://downloads.asterisk.org/pub/telephony/certified-asterisk/certified-asterisk-1.8.15-current.tar.gz

			# Instalando DAHDI
			tar xvfz dahdi-linux-complete-current.tar.gz
			cd dahdi-linux-complete*
			make all
			make install
			make config
			
			clear
			cd ..
			# DAHDI Instalado

			#Instaldo LIBPRI
			cd /usr/src
			tar xvfz libpri-1.4-current.tar.gz
			cd libpri-1.4.14
			make
			make install
			cd ..
			
			clear
			#Instalando ASTERISK
			cd /usr/src/
			rm -rf certified-asterisk-1.8.15-cert4 

			tar zxvf certified-*
			cd certified-*
			make distclean
			./configure
			contrib/scripts/get_mp3_source.sh
			make menuselect.makeopts
			menuselect/menuselect --disable CORE-SOUNDS-EN-GSM --enable app_mysql --enable cdr_mysql --enable res_config_mysql --enable cdr_odbc --enable res_odbc --enable res_config_odbc --enable  format_mp3 --enable cdr_csv menuselect.makeopts
			make
			make install
			make config
			make samples
			cd ..
			echo done
			ExitFinish=1
			bash install-asterisk.sh
		;;

		2)

		
		      #Instalando ASTERISK
			clear
                        cd /usr/src/
                        wget -c http://downloads.asterisk.org/pub/telephony/certified-asterisk/certified-asterisk-1.8.15-current.tar.gz
			rm -rf certified-asterisk-1.8.15-cert4

                        tar zxvf certified-*
                        cd certified-*
                        make distclean
                        ./configure
                        contrib/scripts/get_mp3_source.sh
                        make menuselect.makeopts
                        menuselect/menuselect --disable CORE-SOUNDS-EN-GSM --enable app_mysql --enable cdr_mysql --enable res_config_mysql --enable cdr_odbc --enable res_odbc --enable res_config_odbc --enable  format_mp3 --enable cdr_csv menuselect.makeopts
                        make
                        make install
                        make config
                        make samples
			cd ..
                        echo done
                        ExitFinish=1
                        bash install-asterisk.sh

		;;



                3)

                        #Instalar o ToFalando IPBX
                        clear
			cd /usr/src/
                        wget --no-check-certificate https://raw.github.com/eluizbr/VOXIPBX/master/install/install-tofalando.sh
                        ExitFinish=1
			bash install-tofalando.sh
                ;;


		4)

  			#Instalar o Portabilidade IPBX
        		clear
			cd /usr/src/
        		wget --no-check-certificate https://raw.github.com/eluizbr/VOXIPBX/master/install/install-portabilidade.sh
        		bash install-portabilidade.sh
			ExitFinish=1
			bash install-asterisk.sh
		;;

                5)

                        #Instalar o G729 FREE
                        clear
			cd /usr/src/
                        wget --no-check-certificate https://raw.github.com/eluizbr/VOXIPBX/master/install/install-g729.sh
                        bash install-g729.sh
                        ExitFinish=1
                        bash install-asterisk.sh
                ;;


		0)
        		ExitFinish=1
		;;
		*)
	esac
done
