# Debuger avec X11

Rentrer dans le container
```
docker-compose run builder bash
<appuyer sur ENTER pour que le prompt s'affiche>

```

Lancer le serveur X
/etc/init.d/xvfb start

Installer et lancer fluxbox
apt install fluxbox
fluxbox &

lancer le serveur VNC 
x11vnc  -bg -nopw  -xkb

J'ai copie la ligne de Wikipedia, en virant display parce que la variable d'environnement DISPLAY est dejà en place et le localhost par ce qu'on veux se connecter à distance

Lire address ip du container:
ip address show dev eth0

Se connecter avec le viewer sur votre pc:
vncviewer -encodings 'copyrect tight zrle hextile' 172.21.0.2:5900

Lancer sakia
sakia
