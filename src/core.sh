#!/bin/bash

source src/init.sh
source src/actions.sh
source src/game.sh

#ecrit dans char.txt
function char {
	rm -rf "$DEF_PATH/char.txt"
	for i; do echo $i >> "$DEF_PATH/char.txt"; done
}

#crée une nouvelle partie
function newchar {
	cd $DEF_PATH; clear; #count=0;

	read -p "Quel est ton nom jeune aventurier?" nom ; clear
	read -p "Bienvenue, $nom, raconte moi ton histoire..." description ; clear
	pvmax=$((10 + ($RANDOM % 10)))
	pv=$pvmax
	echo -e "Je vois que tu as $pvmax PV.\n\nPour commencer ton aventure, choisi une arme dans la liste suivante:"
	echo -e "\E[37;44m"
	echo Arme 1:; cut -d: -f1,2 ./lib/armes.txt | sed -n '1p'
	echo Arme 2:; cut -d: -f1,2 ./lib/armes.txt | sed -n '2p'
	echo Arme 3:; cut -d: -f1,2 ./lib/armes.txt | sed -n '3p'
	echo -e "\033[0m"
	#a securiser
	read -p 'Selectionnez le numéro de votre arme:
	' nbarme
	char "$nom" "$description" "$pvmax" "$pv"
	sed -n $nbarme'p' ./lib/armes.txt >> char.txt
	start	
}

#Affiche la feuille de personnage
function perso {
	nb=0
	declare -a affichage
	while read ligne ; do
		affichage[$nb]=$ligne 
		nb=$nb+1
	done < $DEF_PATH"/char.txt"
	echo -e "\033[1;30;47mFiche de personnage :
	Nom : ${affichage[0]}
	Description : ${affichage[1]}
	PV Max : ${affichage[2]}
	PV Courrant : ${affichage[3]}
	Arme :  ${affichage[4]}"
	echo -e "Lieu : "$(basename "${perso[5]}")"\033[0m"
}

