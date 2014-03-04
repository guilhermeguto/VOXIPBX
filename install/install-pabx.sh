#!/bin/bash
# Identify Linux Distribution type
func_identify_os() {
    if [ -f /etc/debian_version ] ; then
        DIST='DEBIAN'
        if [ "$(lsb_release -cs)" != "precise" ]; then
            echo "A instalação funciona apenas no Ubuntu LTS 12.04"
            exit 255
        fi
    else
        echo "A instalação funciona  apenas no Ubuntu LTS 12.04 "
        exit 1
    fi
}

func_identify_os

echo ""
echo ""
echo "Este script irá instalar o ToFalando IPBX neste computador"
echo "Prescione Enter para continuar CTRL-C para sair"
echo ""
read TEMP


case $DIST in
    'DEBIAN')
        apt-get -y update
        apt-get -y install vim git-core
    ;;
esac

#Instalar o Asterisk
cd /usr/src/
wget --no-check-certificate  https://raw.github.com/eluizbr/VOXIPBX/master/install/install-asterisk.sh
bash install-asterisk.sh
/etc/init.d/asterisk start

