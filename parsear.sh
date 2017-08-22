#!/bin/bash

if [[ $# != 1 ]]
then
        exit 1
fi

FILE=`basename "$1"`
COMUNA=${FILE%.*}
TXT_OUTPUT="$COMUNA.txt"
OUTPUT="$COMUNA.csv"
pdftotext -layout "$FILE" "$TXT_OUTPUT"

FLAG=""
REGION_RE="REGI.N\s*:\s*(.*)COMUNA"
PROVINCIA_RE="PROVINCIA\s*:\s*(.*)\s*"
DATOS_DIR_RE="^([^0-9]*)\s+([0-9]{1,2}\.[0-9]{3}\.[0-9]{3}-[0-9Kk])\s*(VAR|MUJ)\s+(.*)\s\s+([A-Za-z'Ññ()][A-Za-z'Ññ() ]+)\s\s+([0-9]+\s?[A-Z]?)$"
echo "NOMBRE,RUT,SEXO,REGION,PROVINCIA,COMUNA,DIRECCION,CIRCUNSCRIPCION,MESA" >> "$OUTPUT"
while read LINEA
do
        if [[ $LINEA =~ ^REP.BLICA ]]
        then
                FLAG=""
        elif [[ $LINEA =~ ^NOMBRE ]]
        then
                FLAG="NOMBRE"
        fi
        if [[ $FLAG == "" && $LINEA =~ $REGION_RE ]]
        then
                REGION=`echo ${BASH_REMATCH[1]} | xargs -0`
        elif [[ $FLAG == "" && $LINEA =~ $PROVINCIA_RE ]]
        then
                PROVINCIA=`echo ${BASH_REMATCH[1]} | xargs -0`
        elif [[ $FLAG  == "NOMBRE" ]]
        then
                if [[ $LINEA =~ $DATOS_DIR_RE ]]
                then
                        NOMBRE=`echo ${BASH_REMATCH[1]} | sed -e "s/\"/'/" | xargs -0`
                        RUT="${BASH_REMATCH[2]}"
                        SEXO="${BASH_REMATCH[3]}"
                        DIRECCION=`echo ${BASH_REMATCH[4]} |sed -e "s/\"/'/" | xargs -0`
                        CIRCUNSCRIPCION=`echo ${BASH_REMATCH[5]} | xargs -0`
                        MESA="${BASH_REMATCH[6]}"
                        echo "\"${NOMBRE}\",\"${RUT}\",\"${SEXO}\",\"${REGION}\",\"${PROVINCIA}\",\"${COMUNA}\",\"${DIRECCION}\",\"${CIRCUNSCRIPCION}\",\"${MESA}\"" >> "$OUTPUT"
                fi
        fi
done < "$TXT_OUTPUT"

rm "$TXT_OUTPUT"
