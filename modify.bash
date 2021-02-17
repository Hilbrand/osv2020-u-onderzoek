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
      if [[ $subdir =~ ^elect-technical-password ]]; then
        subdir="elect-technical"
      fi
      if [[ $subdir =~ ^elect-base-extension-csv ]]; then
        subdir="elect-base-extension"
      fi
      if [[ $subdir =~ ^elect-common-extension-personenregister ]]; then
        subdir="elect-common-extension"
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

function fixSitzberechnung {
  rm nl-sitzberechnung/nl-sitzberechnung-osv-legacy/src/main/java/de/pom.xml
  dir="nl-sitzberechnung/nl-sitzberechnung-osv-legacy/src/main/java/de/ivu/wahl/result/determination"
  for f in `grep -L "package de.ivu.wahl.result.determination" $dir/*`
  do
    rm $f
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
  fixSitzberechnung
}

function check {
  if [ ! -e "$1/nl-was-jar-1.3.9" ]; then
    echo Heb je de juiste directory meegegeven waar de OSV2020-u broncode staat.
    echo
    exit 1;
  fi
}

function gitInit {
  echo Stel originele broncode veilig met git  
  find . -type f -exec dos2unix {} \; 2>&1 > /dev/null 
  git init
  git add .
  git commit -m "Originele broncode"
}

function gitTransform {
  echo Transformeer de broncode
  codefixes 
  git add .
  git commit -m "Verplaats en hernoem broncode"
}

function gitPatch {
  echo Pas patch bestand $1 toe
  git apply $RUN_DIR/$1 -v --reject
  git add .
  git rm *.rej
  git commit -m "$2"
}

######################## HOOFDPROGMMA ########################

check $1

RUN_DIR=`pwd`
cd $1

gitInit
gitTransform
gitPatch osv2020-u.patch 'Patch met aanpassingen en extra pom.xml bestanden'
gitPatch osv2020-u-dummy.patch 'Patch met dummy implementaties van ontbrekende classen'

echo Het zou nu moeten werken om met maven de code te bouwen.
