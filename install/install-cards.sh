#!/bin/bash

    clear
    echo " > Instalar PLACAS ToFalando"
    echo "====================================="
    echo "  1)  Instalar PLacas  E1 - R2"
    echo "  2)  Instalar SIP / VOIP apenas"
    echo "  3)  Instalar Placas"
    echo "  4)  Instalar PABX ToFalando"
    echo "  5)  Instalar Portabilidade"
    echo "  6)  Instalar G729 FREE"
    echo "  7)  Instalar Mesa Operadora"	
    echo "  0)  Sair"
    echo -n "(0-7 : "
    read OPTION < /dev/tty

ExitFinish=0

while [ $ExitFinish -eq 0 ]; do


	 case $OPTION in

		1)
			clear
			cd /usr/src/
		#	wget -c http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-2.9.0+2.9.0.1.tar.gz
		#	wget -c http://downloads.asterisk.org/pub/telephony/libpri/libpri-1.4-current.tar.gz
		#	wget -c http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-1.8.26.1.tar.gz

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

				wget -c http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-2.9.0+2.9.0.1.tar.gz				
                                exit 0
			else

                                wget -c https://openr2.googlecode.com/files/openr2-1.3.3.tar.gz
                                tar xvfz openr2-1.3.3.tar.gz
                                ln -s openr2-1.3.3 openr2
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

