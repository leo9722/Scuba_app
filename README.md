# Scuba_app

![alt text](https://github.com/leo9722/Scuba_app/blob/main/images/imgLittleDiver.png)

Ce projet a pour objectif de concevoir une application autonome sur le thème de la plongée sous-marine.

Une école de plongée souhaite obtenir une application permettant à ses adhérents de pouvoir calculer le profil d’une plongée sous-marine à partir de paramètres entrés.

L’application proposera 2 modes de calcul :

        • Le premier mode, le mode calcul, prendra en compte un profil, une profondeur et un temps de plongée, pour ensuite y afficher les résultats sous forme de graphique et affichera les différentes étapes.

        • Le second mode, le mode simulation, proposera à l’adhérent de renseigner les champs à partir des calculs de l’adhérent, et le système indiquera le résultat!
        

        
## Installation

### Etape 1 

Bien que JAVA soit un langage très utilisé dans le domaine applicatif Android, le sujet mentionne que l’application devait, au départ, fonctionner à la fois sous Android et IOS. 
Ainsi par nos connaissances, nous savions que Google avait créé le langage de programmation “DART” optimisé pour les applications sur plusieurs plateformes. De plus, après quelques recherches, l'utilisation de “FLUTTER” comme Framework, souvent utilisé pour tout ce qui est interface utilisateur, nous a intrigué. Enfin en lisant cet article  
https://www.frandroid.com/android/535194_quest-ce-que-flutter-loutil-permettant-de-creer-des-applications-android-et-ios 
Nous avons pu constater que FLUTTER se fait surtout connaître pour sa capacité à concevoir des applications presque natives, multi plateformes, pour Android et iOS soit exactement ce qu’il fallait pour ce projet.

Ainsi pour mettre en place ce projet il faut creer un projet DART sous Android Studio 

### Etape 2

Une fois le Projet créer, copier coller les fichiers pubspec, lib et images dans votre repertoire afin de remplacer les fichier sources

### Etpae 3

A l'aide de L'IDE Android studio, ouvrez un terminal et faite la commande flutter pub get, afin de mettre à jour les librairies et dépendences utilisé dans ce projet 

### Etape 4 

Enfin une fois tout ceci fait, compiler votre programme et faite le run sur votre appareil.


## Explication


### Mode calcul

Pour obtenir les résultats concernant une plongée, l’utilisateur devra renseigner les informations suivantes :

        • la table de plongée utilisée
        • le profil souhaité
        • la profondeur maximale de la plongée (PR)
        • la durée de la plongée avant remontée (DP)
        • si la profondeur ne fait pas partie des choix, prendre la profondeur en dessous, de même pour la durée
        
Les résultats du mode calcul devront indiquer :

        • le volume d'air restant dans la bouteille pour chaque étape
        • un graphique qui montre les différents paliers à réaliser
        • le temps passé pour chaque étape
        • le moment où la pression de tarage et la pression ambiante est équivalente à la pression contenue dans la bouteille
        • la pression restante dans la bouteille à chaque étape

Il y aura la possibilité de réaliser des calculs pour une plongée successive, il faudra alors prendre en compte les coefficients d’azote.

Les paramètres généraux d’une plongée sont les suivants :

        • respiration moyenne d’une personne : 20 l/minutes
        • vitesse de descente : 20 m/minutes
        • vitesse de remontée avant le premier palier : 10 m/minutes
        • vitesse de remontée entre les paliers : 6 m/minutes



### Mode simulation

Pour calculer le profil de plongée, l’utilisateur devra renseigner les informations suivantes :

        • la table de plongée utilisée
        • la profondeur maximale de la plongée (PR)
        • la durée de la plongée avant remontée (DP)
        • le temps au palier à 3 mètres
        • le temps au palier à 6 mètres
        • le temps au palier à 9 mètres
        • le temps au palier à 12 mètres
        • le temps au palier à 15 mètres

Le résultat du mode simulation devra indiquer un résultat vrai ou faux en fonction de la validité du calcul, ainsi que les valeurs incorrectes avec leur correction.

Gestion d’un profil

L’application présentera une gestion de profil. L’utilisateur devra renseigner les informations suivantes dans la création d’un profil :

        • Tarage du détendeur 
        • Vitesse de descente 
        • Vitesse de remontée avant le premier palier
        • Vitesse de remontée entre les paliers 
        • Consommation au litres / minute
        • Nombres de bouteilles
        • Nom du profil 
        • Volume de la bouteille (choix entre 9,12, 15 ou 18 litres)
        • Pression de remplissage de la bouteille (par défaut 200 bars)

