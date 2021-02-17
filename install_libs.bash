#/bin/bash

# Dit script installeert de missende bibliotheken in de lokale maven repostiory door deze uit de war te halen van de geinstalleerde versie van de software.

WARFILE=nl-was-war.war
FILE=$1/$WARFILE
TMPDIR=/tmp

if [[ $1 == '' ]]; then
  echo Roep script aan met directory waar software geinstalleerd is en een WEB-INF directory is.
  echo
  echo './install_libs.bash <osv installatie directorie>'
  echo
  exit 1;
fi
if [ ! -e "$FILE" ]; then
  echo Kan war bestand niet vinden: $FILE
  echo
  exit 1;
fi
unzip $FILE -d $TMPDIR/$WARFILE > $TMPDIR/$WARFILE.unzip.log

ROOT=$TMPDIR/$WARFILE/WEB-INF/lib/
cd $ROOT
mvn install:install-file -Dfile=${ROOT}document-generator-annotations-2.4.1.jar
mvn install:install-file -Dfile=${ROOT}document-generator-generator-2.4.1.jar
mvn install:install-file -Dfile=${ROOT}document-generator-core-2.4.1.jar
mvn install:install-file -Dfile=${ROOT}document-generator-odt-2.4.1.jar
mvn install:install-file -Dfile=${ROOT}velocity-template-engine-core-2.2.0.jar
mvn install:install-file -Dfile=${ROOT}velocity-template-engine-interfaces-2.2.0.jar
mvn install:install-file -Dfile=${ROOT}ivu-jsefa-addon-1.1.0.jar
mvn install:install-file -Dfile=${ROOT}jopendocument-2.1.0.jar
