# Devmicroserver
Un mini-environnement de développement web pour débutant ou juste tester rapidement son code HTML,Css...
                                                   
## Fonctionnalitées:
* Démarre un serveur web minimaliste.
* Crée une arborescence de dossiers s'ils n'existent pas.
````
MicroServer/
├── exemple.html
├── multimédia
│   ├── audios
│   ├── autres
│   ├── ebooks
│   ├── images
│   └── vidéos
└── styles
    └── exemple.css
````
* Lance une page firefox sur le dossier de travail.
* Crée un fichier d'exemple HTML et un fichier Css.
* La page du navigateur se rafraichie automatiquement à chaque modification.
                                                                                           
## Usage
```bash
./devmicroserver.sh
```
1. Lancer le script là où vous voulez placer votre environnement de développement.
2. Quand la page du navigateur s'affiche cliquer sur le fichier .html pour afficher vôtre site.
3. Ouvrez votre éditeur de code et commencer à coder vos pages. 

## Limits:
*  Fonctionne seulement sur les distribution dérivées de Debian.
*  Fonctionne seulement avec le navigateur Firefox.
*  A besoin des paquets: python3, xdotool et firefox.
*  Utilise le port 8081.                                             
                                                                                            
## Captures d'écran

### Lancement du script
![capture1](cap1img.png)

### Page du navigateur
![capture2](cap2img.png)
