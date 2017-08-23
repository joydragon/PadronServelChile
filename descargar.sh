#!/bin/bash

# 
# Para este script necesitas los siguientes ejecutables instalados:
#       xmlstarlet

hash xmlstarlet 2>/dev/null || { echo >&2 "Error: Necesito que este instalado el programa 'xmlstarlet'."; exit 1; }

PARSE="no"
while true; do
	read -p "Quieres solo descargar (D)? o pasarlo a CSV tambien (C)? o salir (otro)? " opt
	case $opt in
	        [Dd]* ) break;;
	        [Cc]* ) PARSE="yes";break;;
	        * ) exit;;
	esac
done

URL_Archivos_Padron="http://cdn.servel.cl/padronesauditados/archivos.xml"
XML_Archivos_Padron="./archivos.xml"
DEL_Archivos_Padron="./archivos.del"

BASE_Padron_PDF="http://cdn.servel.cl/padronesauditados/padron/"

wget -q "$URL_Archivos_Padron" -O "$XML_Archivos_Padron"
xmlstarlet sel -t -m /Regiones/Region/comunas/comuna -v "concat(nomcomuna,'--',archcomuna)" -n "$XML_Archivos_Padron" > "$DEL_Archivos_Padron"

while read LINEA
do
        COMUNA=""
        ARCHIVO=""
        if [[ $LINEA =~ (.*)--(.*) ]]
        then
                COMUNA=${BASH_REMATCH[1]}
                ARCHIVO=${BASH_REMATCH[2]}
		echo "Descargando ${COMUNA}.pdf ..."
                wget -q "${BASE_Padron_PDF}${ARCHIVO}" -O "${COMUNA}.pdf"
		if [[ $PARSE == "yes" ]]
		then
			echo "Ahora comienza la transformacion de ${COMUNA}.pdf a un CSV."
                	/bin/bash ./parsear.sh "${COMUNA}.pdf" &
		fi
        fi
done < "$DEL_Archivos_Padron"

rm ${DEL_Archivos_Padron} ${XML_Archivos_Padron}
