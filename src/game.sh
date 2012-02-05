#!/bin/bash

function isDead { if [ $pv -le 0 ]; then return 0; else return 1; fi }

function game {
	nb=0 
	declare -a perso #Liste Fiche perso
	declare -a pieces #Liste des pièces accessibles

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



	#On récupère les pièces disponibles
	for i in $(ls -d */); do pieces[$nb]=$i; let "nb+=1"; done
	
	echo "Actions:"
	echo "A) Attaquer le Monstre"
	nb=0
	for i in "${pieces[@]}"; do echo $nb") Aller : $i"; let "nb+=1"; done
	echo "C) Chercher un Passage Secret"
	echo "M) Menu Principal"
	echo "P) Utiliser Potion"
	if [ "$lieu" != "entree" ]; then echo "R) Reculer d'une pièce"; fi
	echo "Q) Quitter"

	read choice 
        case "$choice" in
		a|A) fight;;
                q|Q) exit;;
		c|C) secret;;
                m|M) menu;;
		p|P) potion;;
		r|R) reculer;;
		0|1|2|3|4|5) move $choice;;
                *) echo "Choix non valide..."
        esac
	#On enregistre la configuration du joueur:
	char "${perso[0]}" "${perso[1]}" "${perso[2]}" "$pv" "$arme" `pwd`
	if [ !isDead ]; then game; fi; #On relance
}
