# ColDyArt

Collaborative Dynamic Art is a collaboration between researchers of CERV/Lab-STICC and the derezo Troup to construct an interactive dynamic artistic paint. Creators control the system from their cellphone and the rendering is available in real time on the net.

Dependencies : Nodes and Three.js

Pierre De Loor

# Pour le test de décembre

* Liste des liens
	* / => lien vers le test pour candidat
	* /controller => lien vers le controller
	* /candidates.csv => Récupérer la liste des clients en .csv

# Accéder au serveur de test

[Client](http://coldyart.atrevrix.fr/)

[Render](http://render.coldyart.atrevrix.fr/)

# Installation

Installer nodejs et npm sur la distribution cible

Installer nodejs :

  sudo apt-get install nodejs nodejs-dev nodejs-legacy

Installer  npm :

  curl -L https://www.npmjs.com/install.sh | sh

Mettre à jour Npm :

  npm install npm -g

Installer Coffee-Script :

  npm install -g coffee-script


# Compilation

A éxecuter à la racine du projet

npm install

coffee -cb --output frontend/js/ Coffee/frontend/

coffee -cb --output backend/ Coffee/backend/

nodejs /backend/server.js



# Script de l'Intégration Continue

npm install

coffee -cb --output frontend/js/ Coffee/frontend/

coffee -cb --output backend/ Coffee/backend/

supervisorctl restart nodejs

# RasberryPI 2
setxkbmap fr -> pour mettre le clavier en français

# Mettre à jour le projet sur le RasberryPI 2
Penser a générer les coffee script (executer les instruction de lancement sans faire l'étape nodejs /backend/server.js)

Copier les sous dossier de coldyart dans le raspberry pi puis la redemmaré pour prendre en compte les modifications.

Connexion par ssh :

En passant par une interface graphique (sftp avec filezilla)

ssh pi@192.168.0.100

Mot de pass : raspberry

Puis copier tous les sous dossier de ColDyArt dans le dossier

/home/pi/Documents/barr-amzer/ColDyArt 

avec scp (Mot de passe : raspberry)

scp -r ColDyArt/* pi@192.168.0.100:/home/pi/Documents/barr-amzer/ColDyArt/.

Puis redemmarer la Raspbeery pi ou connectez vous en ssh puis:

supervisorctl restart nodejs

Pour voir les logs

tail -F /var/log/nodejs.err.log 

tail -F /var/log/nodejs.out.log 


