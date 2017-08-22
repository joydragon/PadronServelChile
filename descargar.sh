#!/bin/bash
#Necesitas los siguientes ejecutables:
#       xmlstarlet
#       pdttotext

URL_Archivos_Padron="http://cdn.servel.cl/padronesauditados/archivos.xml"
XML_Archivos_Padron="./archivos.xml"
DEL_Archivos_Padron="./archivos.del"

BASE_Padron_PDF="http://cdn.servel.cl/padronesauditados/padron/"

wget -q "$URL_Archivos_Padron" -O "$XML_Archivos_Padron"
xmlstarlet sel -t -m /Regiones/Region/comunas/comuna -v "concat(nomcomuna,'--',archcomuna)" -n archivos.xml > "$DEL_Archivos_Padron"

while read LINEA
do
        COMUNA=""
        ARCHIVO=""
        if [[ $LINEA =~ (.*)--(.*) ]]
        then
                COMUNA=${BASH_REMATCH[1]}
                ARCHIVO=${BASH_REMATCH[2]}
                wget -q "${BASE_Padron_PDF}${ARCHIVO}" -O "${COMUNA}.pdf"
                /bin/bash ./parsear.sh "${COMUNA}.pdf" &
        fi
done < "$DEL_Archivos_Padron"
