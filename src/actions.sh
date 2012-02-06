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
	echo -e "Vous entrez en phase de combat avec: $nomMob,\n$desMob";
	while [ "$pvMob" -gt 0 ]; do
		echo -e "Vos Pv: $pv | $nomMob Pv: $pvMob"
		if [ $(($RANDOM%2)) -eq 0 ]; then ((pvMob-=$degArme)); echo "Vous infligez $degArme dommages.";
		else echo "Vous ratez votre attaque..."; fi
		sleep 1;
		if [ $(($RANDOM%2)) -eq 0 ]; then ((pv-=$degMaxMob)); echo "$nomMob vous inflige $degMaxMob dommages.";
		else echo "$nomMob rate son attaque!"; fi
		sleep 1;
		if [ $pv -le 0 ]; then clear; echo "Vous êtes mort... $nomMob vous a vaincu."; menu; fi
	done
	sed $(($1+1))"d" `pwd`/mobs.txt -i
	clear; echo "Vous avez vaincu $nomMob !"
}
function resolve {
	clear;
	echo "${enigmes[$1]}?" | cut -d: -f2
	echo -n "1)"; echo "${enigmes[$1]}?" | cut -d: -f3
	echo -n "2)"; echo "${enigmes[$1]}?" | cut -d: -f4
	echo "A) Annuler"
	echo "Q) Quitter"
	read choice
	case "$choice" in
                q|Q) exit;;
		a|A) game;;
		1|2) let "choice+=2";	if [ $(echo "${enigmes[$1]}" | cut -d: -f$(($choice))) == $(echo "${enigmes[$1]}" | cut -d: -f5) ]; then
				clear; echo "Vous avez réussi l'énigme"; sed $(($1+1))"d" `pwd`/enigmes.txt -i;
			else	clear; echo "Vous avez échoué et mourrez dans d'atroces souffrances..."; menu; fi;;
                *) echo "Choix non valide..."
        esac	
}

function choice { if [ ! $mobsCount -eq 0 ]; then fight $1; elif [ ! $enigmesCount -eq 0 ]; then resolve $1; else move $1; fi }
#Utilise le passage secret si il est disponible
function secret {
	if [ $(ls -F | grep @ -c) -eq 0 ]; then clear; echo "Il n'y a pas de passage secret ici.";
	else clear; echo "Il y a un passage secret ici. Il mène vers" $(ls -F | grep @ | cut -d@ -f1); cd $(ls -F | grep @ | cut -d@ -f1)
	fi
}
#Retourne dans la pièce précédente
function reculer {
	if [ "$lieu" != "entree" ]; then cd ..; clear;
	else clear; echo "Vous ne pouvez pas reculer...";
	fi
}

function drink {
	pvSup=$(echo ${potions[$1]} | cut -d: -f3)
	let "pv+=pvSup"
	[ $pv -gt $pvMax ] && ((pv=$pvMax));
	clear; echo "Vous avez utilisé la potion: ${potions[$1]}" | cut -d: -f1,2
	sed $(($1+1))"d" `pwd`/potions.txt -i
}
function potion {
	clear
	nb=0
	echo "Potion(s) Disponible(s):"
	for i in "${potions[@]}"; do 
		echo "-$i" | cut -d: -f1; 
		echo "$i" | cut -d: -f2;
		let "nb+=1"; 
	done;
	nb=0
	if [ ! $potionsCount -eq 0 ]; then
		for i in "${potions[@]}"; do echo $nb") Utiliser : $i" | cut -d: -f1,2; let "nb+=1"; done;
		echo "A) Annuler"
		echo "Q) Quitter"
		read choice 
        case "$choice" in
                q|Q) exit;;
		a|A) game;;
		0|1|2|3|4|5) drink $choice;;
                *) echo "Choix non valide..."
        esac
	else	echo "Vous ne trouvez aucune potion dans la pièce..."; fi
}
