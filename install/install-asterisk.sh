#!/bin/bash

# Copyright (C) 2011-2014 ToFalando
#
# Script incialmente desenvolvido por
# Emerson Luiz ( eluizbr@tofalando.com.br )


source funcoes.sh
# Configurar o Branch
#BRANCH='devel'

    clear
    echo " > Instalar ToFalando IPBX"
    echo "====================================="
    echo "  1)  Instalar Central E1 / Placas"
    echo "  2)  Instalar Central SIP"
    echo "  3)  Instalar Placas"
    echo "  4)  Instalar PABX ToFalando"
    echo "  5)  Instalar Portabilidade"
    echo "  6)  Instalar G729 FREE"
    echo "  7)  Instalar Mesa Operadora"	
    echo "  0)  Sair"
    echo -n "(0-7) : "
    read OPTION < /dev/tty

ExitFinish=0

while [ $ExitFinish -eq 0 ]; do


	 case $OPTION in

		1)

                        #Instalar Placas
                        clear
                        cd /usr/src/
                        wget --no-check-certificate https://raw.github.com/eluizbr/VOXIPBX/$BRANCH/install/install-cards.sh
                        ExitFinish=1
                        bash install-cards.sh
		;;

		2)

		
		      #Instalando ASTERISK
			clear
			func_install_asterisk
			bash install-asterisk.sh
		;;


                3)

                        #Instalar Placas
                        clear
                        cd /usr/src/
                        wget --no-check-certificate https://raw.github.com/eluizbr/VOXIPBX/$BRANCH/install/install-cards.sh
                        ExitFinish=1
                        bash install-cards.sh
                ;;


                4)

                        #Instalar o ToFalando IPBX
                        clear
			cd /usr/src/
                        wget --no-check-certificate https://raw.github.com/eluizbr/VOXIPBX/$BRANCH/install/install-tofalando.sh
                        ExitFinish=1
			bash install-tofalando.sh
                ;;


		5)

  			#Instalar o Portabilidade IPBX
        		clear
			func_install_portabilidade
			ExitFinish=1
			bash install-asterisk.sh
		;;

                6)

                        #Instalar o G729 FREE
                        clear
			cd /usr/src/
        #                wget --no-check-certificate https://raw.github.com/eluizbr/VOXIPBX/$BRANCH/install/install-g729.sh
         #               bash install-g729.sh
          #              ExitFinish=1
           #             bash install-asterisk.sh
                        
                        # Checar asterisk

		if [ ! -d "/etc/asterisk" ]; then

                        clear
			cd /usr/src/		
			func_install_asterisk
			func_install_g729
			bash install-asterisk.sh
        	        ExitFinish=1

		
		else
                        clear
			cd /usr/src/
			func_install_g729
			bash install-asterisk.sh
	           ExitFinish=1

		fi
		
		
# Fim seta CPU

                        
                ;;

                7)

                        #Instalar a Mesa Operadora
                        clear
                        func_install_mesa
                        bash install-asterisk.sh
                ;;


		0)
        		clear
			cd /usr/src/
			rm -rf asterisk* dahdi* lib* install* fop*  funcoes* linux* openr2*
			# Apaga Instalacao
			cd /var/www/ipbx/
			rm -rf install

			ExitFinish=1
		;;
		*)
	esac
done

