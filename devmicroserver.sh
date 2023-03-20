#!/bin/bash

#--------------------------------------------------#
# Script_Name: devmicroserver.sh	                               
#                                                   
# Author:  'dossantosjdf@gmail.com'                 
# Date: lun. 20 mars. 2023 08:32:00                                             
# Version: 1.0                                      
# Bash_Version: 5.1.16(1)-release                                     
#--------------------------------------------------#
# Description:                                      
#  Permet d'avoir un mini-environnement de développement web pour débutant ou juste tester rapidement son code HTML,Css...
#                                               
# Fonctionnalitées:
#  Démarre un serveur web minimaliste.
#  Crée une arborescence de dossiers s'ils n'existent pas.
#  Lance une page firefox sur le dossier de travail.
#  Crée un fichier d'exemple HTML et un fichier Css.
#  La page du navigateur se rafraichie automatiquement à chaque modification.
#                                                                                            
# Usage: ./devmicroserver.sh
#
# Limits:
#  Fonctionne seulement sur les distribution dérivées de Debian.
#  Fonctionne seulement avec le navigateur Firefox.
#  A besoin des paquets: python3, xdotool et firefox.
#  Utilise le port 8081.                                             
#                                                                                            
#--------------------------------------------------#

set -ue

# Functions
endscpt() {
  echo -e "\n\n\n Arrêt du serveur !"
  kill $pidpysrv 2> /dev/null
  tput sgr0
  exit 0
}

# Variables
currentdir="$(pwd)"
microsrvdir="${currentdir}/MicroServer"

ipsrv="$(hostname -I | awk '{print $1}')"
srvport="8081"

reloadkeys="CTRL+F5"

## Main ##
clear

cat << EOF
 ____             __  __ _               ____                           
|  _ \  _____   _|  \/  (_) ___ _ __ ___/ ___|  ___ _ ____   _____ _ __ 
| | | |/ _ \ \ / / |\/| | |/ __| '__/ _ \___ \ / _ \ '__\ \ / / _ \ '__|
| |_| |  __/\ V /| |  | | | (__| | | (_) |__) |  __/ |   \ V /  __/ |   
|____/ \___| \_/ |_|  |_|_|\___|_|  \___/____/ \___|_|    \_/ \___|_|   
                                                                                                                             
EOF

# Installing dependencies
echo -e "\n Vérification des dépendances ... \n"

if (command -v apt-get 2> /dev/null)
then
  for appinstall in 'xdotool' 'python3' 'firefox'
  do
    if ! (dpkg -L $appinstall > /dev/null) || ! (command -v $appinstall > /dev/null)
    then
      sudo apt-get update -qq
      if ! (sudo apt-get install $appinstall -qqy)
      then
        echo -e "\n Installation de $appinstall Impossible! \n"
        exit 1
      fi
    fi
  done
fi

if ! [[ -d $microsrvdir ]]
then
  # Creation of the tree structure
  echo -e "\n Création de l'arboresence des dossiers et fichiers ... \n"
  mkdir -p ${microsrvdir}/{styles,multimédia/{audios,vidéos,images,ebooks,autres}}

  # Creating the Sample HTML Page
  touch ${microsrvdir}/exemple.html
  cat > ${microsrvdir}/exemple.html << EOF
<!doctype html>
<html lang="fr">
  <head>
    <meta charset="utf-8">
    <title>DevMicroServer</title>
    <link rel="stylesheet" href="styles/exemple.css">
  </head>
  <body>
    <!-- Ceci est un commentaire -->
    <h1>DevMicroServer</h1>
    <h2 id="exemple">Cette page est un exemple !</h2>
    <h2>C'est quoi ?</h2>
    <p>Un mini-environnement de développement web pour débutant ou juste tester rapidement son code HTML,Css...</p>
    <h2>Les fonctionnalités</h2>
    <ul>
      <li>Démarre un serveur web minimaliste.</li>
      <li>Crée une arborescence de dossiers s'ils n'existent pas.</li>
      <li>Lance une page Firefox sur le dossier de travail.</li>
      <li>Crée un fichier d'exemple HTML et un fichier Css.</li>
      <li>La page du navigateur se rafraichie automatiquement à chaque modification.</li>
    </ul>
  </body>
</html>

EOF

  # Creating the Sample Css Page
  touch ${microsrvdir}/styles/exemple.css
  cat > ${microsrvdir}/styles/exemple.css << EOF
/*
Ceci est un commentaire
*/

body {
  background-color:lightcyan;
}

h1 {
  color:cornflowerblue;
  background-color: black;
  text-align: center;
}

h2 {
  color:cornflowerblue;
}

#exemple {
  color:rgb(48, 189, 67);
  text-align: center;
}

p,ul {
  color: blue;
}

EOF

fi

# Start server
echo -e "\n Démarrage du serveur web ... \n"
python3 -m http.server --bind $ipsrv --directory $microsrvdir $srvport &
# Get the pid
pidpysrv="$!"

trap endscpt EXIT INT ERR

# Open a web page
firefox --private-window http://${ipsrv}:${srvport} &

# Refresh the page each time folders or files are modified
mapfile -t ctdir < <(stat --format='%Z' MicroServer/{*.html,*/*.css,*,*/*})  

while :
do
  mapfile -t compctdir < <(stat --format='%Z' MicroServer/{*.html,*/*.css,*,*/*})
  if [[ "${compctdir[*]}" == "${ctdir[*]}" ]]
  then
    printf "%s En écoute de modifications ... %s , URL: http://%s:%s, CTRL + c pour quitter ! \r" "$(tput setaf 0; tput setab 2; tput blink)" "$(tput sgr0)" "$ipsrv" "$srvport"
    continue
  else
    xdotool search --onlyvisible --name "Navigation privée" windowfocus key --clearmodifiers $reloadkeys
    mapfile -t ctdir < <(stat --format='%Z' MicroServer/{*.html,*/*.css,*,*/*})
  fi  
done
