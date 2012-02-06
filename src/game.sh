#!/bin/bash

function isDead { if [ $pv -le 0 ]; then return true; else return false; fi }

function game {
	nb=0 
	declare -a perso pieces mobs potions enigmes armes

	#On récupère les infos du fichier char.txt
	while read ligne ; do perso[$nb]=$ligne; let "nb+=1";
	done < "$DEF_PATH"/char.txt
	lieu=$(basename "${perso[5]}"); 
	declare -i pvMax="${perso[2]}"
	declare -i pv="${perso[3]}"
	arme="${perso[4]}"
	nomArme=$(cut -d : -f 1 $DEF_PATH"/char.txt" | sed -n '5p')
	degArme=$(cut -d : -f 3 $DEF_PATH"/char.txt" | sed -n '5p')
	nb=0
	echo -e "------------------\n${perso[0]}\nPV Max: $pvMax\nPV Courrant: $pv\nArme:  $nomArme\n------------------\n|Lieu:  $lieu"
	
	mobsCount=0 #On récupère les monstres
	if [ -f "${perso[5]}"/mobs.txt ]; then 
		while read ligne ; do mobs[$mobsCount]=$ligne; let "mobsCount+=1";
		done < "${perso[5]}"/mobs.txt; fi
	potionsCount=0	#On récupère les potions disponibles
	if [ -f "${perso[5]}"/potions.txt ]; then 
		while read ligne ; do potions[$potionsCount]=$ligne; let "potionsCount+=1";
		done < "${perso[5]}"/potions.txt; fi
	enigmesCount=0	#On récupère les énigmes disponibles
	if [ -f "${perso[5]}"/enigmes.txt ]; then 
		while read ligne ; do enigmes[$enigmesCount]=$ligne; let "enigmesCount+=1";
		done < "${perso[5]}"/enigmes.txt; fi
	nb=0	#On récupère les pièces disponibles
	for i in $(ls -d */ 2>/dev/null); do pieces[$nb]=$i; let "nb+=1"; done

	echo -e "|Monstres: $mobsCount\n|Potions: $potionsCount\n|Enigmes: $enigmesCount\n------------------";
	
	echo "Actions:"; nb=0;
	
	if [ ! $mobsCount -eq 0 ]; then for i in "${mobs[@]}"; do echo $nb") Attaquer : $i" | cut -d: -f1,2; let "nb+=1"; done
	elif [ ! $enigmesCount -eq 0 ]; then for i in "${enigmes[@]}"; do echo $nb") Résoudre l'énigme : $i" | cut -d: -f1,2; let "nb+=1"; done
	else for i in "${pieces[@]}"; do echo $nb") Aller : $i"; let "nb+=1"; done; fi
	
	echo "C) Chercher un Passage Secret"
	echo "M) Menu Principal"
	[ ! $potionsCount -eq 0 ] && echo "P) Utiliser Potion";
	if [ "$lieu" != "entree" ]; then echo "R) Reculer d'une pièce"; fi
	echo "Q) Quitter"

	read choice 
        case "$choice" in
                q|Q) exit;;
		c|C) secret;;
                m|M) menu;;
		p|P) potion;;
		r|R) reculer;;
		0|1|2|3|4|5) choice $choice;;
                *) echo "Choix non valide..."
        esac
	#On enregistre la configuration du joueur:
	char "${perso[0]}" "${perso[1]}" "${perso[2]}" "$pv" "$arme" `pwd`
	if [ !isDead ]; then game; fi; #On relance
}
