#!/bin/bash

    clear
    echo " > Instalando Asterisk"
    echo "====================================="
    echo "  1)  Instalar Asterisk"
    echo "  2)  Instalar PABX ToFalando"
    echo "  3)  Instalar Portabilidade"
    echo "  0)  Sair"
    echo -n "(0-3) : "
    read OPTION < /dev/tty

ExitFinish=0
while [ $ExitFinish -eq 0 ]; do


 case $OPTION in

	1)

cd /usr/src/

wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-1.4-current.tar.gz
wget -c http://downloads.asterisk.org/pub/telephony/certified-asterisk/certified-asterisk-1.8.15-current.tar.gz

tar xvfz dahdi-linux-complete-current.tar.gz
cd dahdi-linux-complete*
make all
make install
make config

cd ..

cd /usr/src
tar xvfz libpri-1.4-current.tar.gz
cd libpri-1.4.14
make
make install
cd ..


cd /usr/src/
rm -rf certified-asterisk-1.8.15-cert4 

tar zxvf certified-*
cd certified-*
make distclean
./configure
contrib/scripts/get_mp3_source.sh
make menuselect.makeopts
menuselect/menuselect --disable CORE-SOUNDS-EN-GSM --enable app_mysql --enable cdr_mysql --enable res_config_mysql --enable cdr_odbc --enable res_odbc --enable res_config_odbc --enable  format_mp3 --enable cdr_csv menuselect.makeopts
#make menuselect
make
make install
make config
make samples

echo done
;;

2)
        #Instalar o ToFalando IPBX
	cd /usr/src/
	wget --no-check-certificate https://raw.github.com/eluizbr/VOXIPBX/master/install/install-tofalando.sh 
	bash install-tofalando.sh
;;

3)

  	#Instalar o Portabilidade IPBX
        cd /usr/src/
        wget --no-check-certificate https://raw.github.com/eluizbr/VOXIPBX/master/install/install-portabilidade.sh
        bash install-portabilidade.sh


        ExitFinish=1
;;

0)
        ExitFinish=1
;;
*)
esac
done

