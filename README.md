# PadronServelChile
Este repositorio es para obtener de una manera automática en un archivo separado por comas (CSV) los registros de todos los ciudadanos registrados para votar (desde servel.cl).

Son sólo scripts en bash por lo que cualquier usuario de Linux (y probablemente Mac) pueda llegar y usarlos. Son principalmente 2 archivos:
- descargar.sh: descarga la lista de archivos de las comunas desde el mismo Servel
- parsear.sh: lee los archivos .pdf con pdftotext (debe estar instalado) para luego pasar esos archivos de texto a un formato CSV.

Para usar los scripts sólo necesitas tener instalado lo siguiente:

- xmlstarlet http://xmlstar.sourceforge.net/, este probablemente tengas que instalar
- pdftotext, es parte de poppler-utils (https://poppler.freedesktop.org/), y está disponible en la mayoría de las distros de Linux
- wget, este debería estar instalado
- sed, este debería estar instalado
- xargs, este debería estar instalado

Y listo! Ya tienes todo lo que necesitas para poder tener esa información automáticamente :)
