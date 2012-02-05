#!/bin/bash

#Déplace le personnage dans la pièce reçue en paramètre
function move {
	if [ "${pieces[$1]}" ]; then cd "${perso[5]}/${pieces[$1]}"; clear; 
	else clear; echo "Cette pièce n'éxiste pas";
	fi
}
#Utilise le passage secret si il est disponible
function secret {
	echo `ls -F`
}
#Retourne dans la pièce précédente
function reculer {
	if ["$lieu" != "entree" ]; then cd ..; clear;
	else clear; echo "Vous ne pouvez pas reculer...";
	fi
}

function potion {
	echo lol;
}
