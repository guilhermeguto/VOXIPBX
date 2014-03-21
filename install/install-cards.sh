#!/bin/bash
source funcoes.sh
    clear
    echo " > Instalar PLACAS ToFalando"
    echo "====================================="
    echo "  1)  Instalar PLaca E1 - R2"
    echo "  2)  Instalar Placa E1 - ISDN "
    echo "  0)  Sair"
    echo -n "(0-2) : "
    read OPTION < /dev/tty

ExitFinish=0

while [ $ExitFinish -eq 0 ]; do


	 case $OPTION in

		1)
			clear
			cd /usr/src/

			# Instalando OpenR2
			if [ ! -d "/usr/src/dahdi" ]; then
			
				printf "Deseja instalar o DAHDI agora? (Y/n): "
				read INPT
			if [ "$INPT" = "n" ]; then 
				bash install-cards.sh
				echo ""
				exit
			fi
				clear
				func_install_oslec
				func_install_openr2
				ExitFinish=1
			else
				clear
				func_install_openr2
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

