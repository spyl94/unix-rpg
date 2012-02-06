#!/bin/bash

#Place les objets dans les salles
function initObjects {
	touch $1/armes.txt $1/enigmes.txt $1/mobs.txt $1/potions.txt $1/enigmes.txt #inutile mais demandé par l'énoncé.
	if [ $(($RANDOM%2)) -eq 0 ]; then
		echo $(sed -n $((1 + ($RANDOM % 11)))"p" $DEF_PATH"/lib/armes.txt") >> $1/armes.txt;
		((nombreArmes++))
	fi
	if [ $(($RANDOM%2)) -eq 0 ]; then
 		echo $(sed -n $((1 + ($RANDOM % 8)))"p" $DEF_PATH"/lib/mobs.txt") >> $1/mobs.txt;
		((nombreMobs++))
	fi
	if [ $(($RANDOM%2)) -eq 0 ]; then
		echo $(sed -n $((1 + ($RANDOM % 4)))"p" $DEF_PATH"/lib/potions.txt") >> $1/potions.txt;
		((nombrePotions++))
	fi
	if [ $(($RANDOM%2)) -eq 0 ]; then
		echo $(sed -n $((1 + ($RANDOM % 8)))"p" $DEF_PATH"/lib/enigmes.txt") >> $1/enigmes.txt;
		((nombreEnigmes++))
	fi
}

#Crée la carte du jeu
function initPlacement {
	find "$DEF_PATH/entree" -type d | (while read A ; do initObjects $A; done
	if [[ "$nombreMobs" -gt 8 && "$nombreEnigmes" -gt 8 ]]; then echo "Génération de la carte terminée."; else initPlacement; fi
	)
}

#Initialise la carte
function initMap {
	rm -Rf $DEF_PATH/entree
	mkdir -p $DEF_PATH/entree/{hall/{chambre/{armoire,bibliotheque},cuisine/coin,salon/{cheminee,etage}},jardin/{cabane,allee}}
	if [ $? != 0 ]; then echo "Impossible de créer la carte."; exit; fi
	#sortie:
	if [ $(($RANDOM%2)) -eq 0 ]; then
		mkdir $DEF_PATH/entree/hall/salon/cheminee/sortie
	else
		mkdir $DEF_PATH/entree/hall/salon/cheminee/sortie
	fi


	#passages secrets:
	ln -s $DEF_PATH/entree/hall/salon/cheminee/ $DEF_PATH/entree/jardin/cabane

	nombreMobs=0;
	nombreEnigmes=0;
	nombreArmes=0;
	nombrePotions=0;
	initPlacement
	#exit;
}
#Initialise la partie
function start {
	initMap
	cd entree
	pwd >> "$DEF_PATH"/char.txt
	clear
	game
}
