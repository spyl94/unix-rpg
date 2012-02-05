#!/bin/bash

function isDead { if [ $pv -le 0 ]; then return 0; else return 1; fi }

function game {
	nb=0 
	declare -a perso pieces mobs potions enigmes armes

	while read ligne ; do perso[$nb]=$ligne; let "nb+=1";
	done < "$DEF_PATH"/char.txt
	#On récupère les infos du fichier char.txt
	lieu=$(basename "${perso[5]}"); 
	pv="${perso[3]}"
	arme="${perso[4]}"
	nomArme=$(cut -d : -f 1 $DEF_PATH"/char.txt" | sed -n '5p')
	degArme=$(cut -d : -f 3 $DEF_PATH"/char.txt" | sed -n '5p')
	nb=0 #cpt
	echo -e "PV Max : ${perso[2]}\nPV Courrant : $pv\nArme :  $nomArme\nLieu :  $lieu"
	
	mobsCount=0
	if [ -f "${perso[5]}"/mobs.txt ]; then 
		while read ligne ; do mobs[$mobsCount]=$ligne; let "mobsCount+=1";
		done < "${perso[5]}"/mobs.txt
	fi
	nb=0 #cpt
	if [ -f "${perso[5]}"/potions.txt ]; then 
		while read ligne ; do potions[$nb]=$ligne; let "nb+=1";
		done < "${perso[5]}"/potions.txt
	fi

	#On récupère les pièces disponibles
	nb=0 #cpt
	for i in $(ls -d */ 2>/dev/null); do pieces[$nb]=$i; let "nb+=1"; done
	
	echo "Actions:"
	nb=0
	
	if [ ! $mobsCount -eq 0 ]; then 
		for i in "${mobs[@]}"; do echo $nb") Attaquer : $i"; let "nb+=1"; done
	else
		for i in "${pieces[@]}"; do echo $nb") Aller : $i"; let "nb+=1"; done
	fi
	echo "C) Chercher un Passage Secret"
	echo "M) Menu Principal"
	echo "P) Utiliser Potion"
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
