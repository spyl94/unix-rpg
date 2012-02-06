#!/bin/bash

#Déplace le personnage dans la pièce reçue en paramètre
function move {
	clear
	if [ "${pieces[$1]}" ]; then cd "${perso[5]}/${pieces[$1]}";
	else echo "Cette pièce n'éxiste pas";
	fi
}
function fight {
	clear
	nomMob=$(echo ${mobs[$1]} | cut -d: -f1)
	desMob=$(echo ${mobs[$1]} | cut -d: -f2)
	declare -i pvMob=$(echo ${mobs[$1]} | cut -d: -f3)
	declare -i degMaxMob=$(echo ${mobs[$1]} | cut -d: -f4)
	echo -e "Vous entrez en phase de combat avec $nomMob\n$desMob";
	while [ "$pvMob" -gt 0 ]; do
		echo -e "Vos Pv: $pv | $nomMob Pv: $pvMob"
		if [ $(($RANDOM%2)) -eq 0 ]; then ((pvMob-=$degArme))
		else echo "Vous ratez votre attaque..."; fi
		sleep 1;
		if [ $(($RANDOM%2)) -eq 0 ]; then ((pv-=$degMaxMob))
		else echo "$nomMob rate son attaque!"; fi
		sleep 1;
		if [ $pv -le 0 ]; then clear; echo "Vous êtes mort... $nomMob vous a vaincu."; menu; fi
	done
	sed $(($1+1))"d" `pwd`/mobs.txt -i
	clear; echo "Vous avez vaincu $nomMob !"
}

function choice { if [ $mobsCount -eq 0 ]; then move $1; else fight $1; fi }
#Utilise le passage secret si il est disponible
function secret {
	echo `ls -F`
}
#Retourne dans la pièce précédente
function reculer {
	if [ "$lieu" != "entree" ]; then cd ..; clear;
	else clear; echo "Vous ne pouvez pas reculer...";
	fi
}

function potion {
	echo lol;
}
