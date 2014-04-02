#!/bin/bash

# Copyright (C) 2011-2014 ToFalando
#
# Script incialmente desenvolvido por
# Emerson Luiz ( eluizbr@tofalando.com.br )

source funcoes.sh
    clear
    echo " > Instalar PLACAS ToFalando"
    echo "====================================="
    echo "  1)  Instalar PLaca E1 - R2"
    echo "  2)  Instalar Placa E1 - ISDN "
    echo "  3)  Instalar Placa TRONCO FXO/FXS "
    echo "  0)  Sair"
    echo -n "(0-3) : "
    read OPTION < /dev/tty

ExitFinish=0

while [ $ExitFinish -eq 0 ]; do


	 case $OPTION in

		1)
			clear
			cd /usr/src/

			# Instalando OpenR2
#			if [ ! -d "/usr/src/dahdi" ]; then
			
#				printf "Deseja instalar o DAHDI agora? (Y/n): "
#				read INPT
#			if [ "$INPT" = "n" ]; then 
#				bash install-cards.sh
#				echo ""
#				exit
#			fi
				clear
				func_install_dahdi
				func_install_openr2
				func_install_asterisk
				cd /usr/src/
				bash install-cards.sh
				ExitFinish=1
#			else
#				clear
#				func_install_dahdi_2
#				func_install_openr2
#				func_install_asterisk
#				cd /usr/src/
#				bash install-cards.sh
#				ExitFinish=1
#			fi

                ;;


		2)
        			clear
        			cd /usr/src/
				clear
				func_install_dahdi
				func_install_libpri
				func_install_asterisk
				cd /usr/src/
				bash install-cards.sh
				ExitFinish=1
		;;

		3)
        			clear
        			cd /usr/src/
				clear
				func_install_dahdi
				func_install_libpri
				func_install_asterisk
				cd /usr/src/
				bash install-cards.sh
				ExitFinish=1
		;;


		0)
        			clear
        			cd /usr/src/
				bash install-asterisk.sh
				ExitFinish=1
		;;
		*)
	esac
done

