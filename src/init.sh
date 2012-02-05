#!/bin/bash

function initObjects {
	if [ $(($RANDOM%2)) -eq 0 ]; then 
		echo "blabla" >> $1/armes.txt; 
		((nombreArmes++))
	fi
	if [ $(($RANDOM%2)) -eq 0 ]; then
 		echo "blabla" >> $1/mobs.txt;
		((nombreMobs++))
	fi
	if [ $(($RANDOM%2)) -eq 0 ]; then 
		echo "blabla" >> $1/potions.txt;
		((nombrePotions++))
	fi
	if [ $(($RANDOM%2)) -eq 0 ]; then 
		echo "blabla" >> $1/enigmes.txt; 
		((nombreEnigmes++))
	fi
}

#Crée la carte du jeu
function initMap {
	rm -Rf $DEF_PATH/entree
	mkdir -p $DEF_PATH/entree/{hall/{chambre/{armoire,bibliotheque},cuisine/coin,salon/{cheminee,etage}},jardin/{cabane,allee}}
	if [ $? != 0 ]; then echo "Impossible de créer la carte."; exit; fi
	#sortie:
	mkdir $DEF_PATH/entree/hall/salon/cheminee/sortie

	nombreMobs=0;
	nombreEnigmes=0;
	nombreArmes=0;
	nombrePotions=0;
	find "$DEF_PATH/entree" -type d | (while read A ; do initObjects $A; done
	if [[ "$nombreMobs" -gt 8 && "$nombreEnigmes" -gt 8 ]]; then echo "c cool"; else initMap; fi
	)

	#passages secrets:
	ln -s $DEF_PATH/entree/hall/salon/cheminee/ $DEF_PATH/entree/jardin/cabane
}



#Initialise la partie
function start {
	initMap
	cd entree
	pwd >> "$DEF_PATH"/char.txt
	clear
	game
}
