#/bin/bash

# Script om code van jar structuur naar java broncode structuur te verplaatsen.

function verplaats  {
    subdir=`echo $2 | sed 's/-[^-]*$//g'`
    if [[ $subdir == 'nl-interfaces' || $subdir == 'elect-interfaces-wus' ]]; then
      echo verplaats $1 naar $2
      mv $1 $2
    else
      if [[ $subdir =~ ^nl-sitzberechnung ]]; then
        subdir="nl-sitzberechnung"
      fi
      if [[ ! -e $subdir ]]; then
        mkdir $subdir
      fi
      echo verplaats $1 naar $subdir/$2
      mv $1 $subdir/$2
    fi
}

function verwijderVersies {
    dirs=`ls`
    for d in $dirs
    do
      newdir=`echo $d | sed 's/-[0-9\.]*$//g'`
      if [ $d != $newdir ]; then
        verplaats $d $newdir
      fi
    done
}

function verwijderClass {
  find . -name *.class -exec rm {} \;
}

function pom {
    poms=`find . -name pom.xml`
    for p in $poms
    do
      parent=$(dirname $p)
      for i in {0..3}
      do
        parent=$(dirname $parent)
      done
      echo kopier pom naar $parent
      cp $p $parent
    done
}

function src {
    src=`find . -name $1 | grep -v .git`
    for s in $src
    do
      parent=$(dirname $s)
      java="$parent/src/main/java"
      echo Verplaats broncode "$1" naar $java
      mkdir -p $java
      mv $s $java
    done
}

function patchGBAV {
    echo Verwijder gegeneerde code
    rm -r gbav/gbav-client/nl
}

function resources {
    resources=`find . -name META-INF`
    for r in $resources
    do
      parent=$(dirname $r)
      resourcedir=$parent/src/main/resources
      echo RESOURCES: $r, parent: $parent, resourcedir: $resourcedir 
      for f in `ls $parent`
      do
        if [[ $f != "pom.xml" ]] && [[ $f != "src" ]]; then
        echo file: $f
          if [[ ! -e $resourcedir ]]; then
            mkdir -p $resourcedir
          fi
          mv $parent/$f $resourcedir
        fi
      done
    done
}

function codefixes {
  verwijderVersies
  verwijderClass
  pom
  src "de"
  src "org"
  src "oasis"
  patchGBAV
  resources
}

if [ ! -e "$1/nl-was-jar-1.2.0.1" ]; then
  echo Heb je de juiste directory meegegeven waar de OSV2020-u broncode staat.
  echo
  exit 1;
fi

RUN_DIR=`pwd`
cd $1

echo Stel originele broncode veilig met git  
find . -type f -exec dos2unix {} \; 2>&1 > /dev/null 
git init
git add .
git commit -m "Originele broncode"

echo Transformeer de broncode
codefixes 
git add .
git commit -m "Verplaats en hernoem broncode"

echo Pas patch bestand toe
git apply $RUN_DIR/osv2020-u.patch -v --reject
git add .
git commit -m "Patch met aanpassingen en extra pom.xml bestanden"

