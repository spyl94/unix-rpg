source src/init.sh
source src/actions.sh
source src/game.sh

#Ecrit dans char.txt
function char {
	rm -rf "$DEF_PATH/char.txt"
	for i; do echo $i >> "$DEF_PATH/char.txt"; done
}

#Victoire
function win {
	echo -e "Vous avez réussi à sortir du labyrinthe vivant...\nOserez-vous retenter l'expérience?"; menu
}

#Confirmation de sauvegarde avant de quitter
function quitter {
	while  read -p "Voulez vous sauvegarder la partie en cours? (o/n)
	" choice ; do
        case "$choice" in
                n|N|q|Q) exit;;
                o|O) save;;
                *) echo "Choix non valide..."
        esac
	done
}
#Sauvegarde
function save {
	read -p "Veuillez indiquer le nom de votre sauvegarde [save]:
	" save;
	if [ ! $save ]; then save="save"; fi
	cd $DEF_PATH
	tar cvf $save.tar.gz entree/ char.txt 1>/dev/null
	rm -rf entree "char.txt"
	clear; echo "Partie Sauvegardée avec succès."; menu
}

#Charge une partie sauvegardée
function load {
	declare -a save perso
	cd $DEF_PATH; clear; nb=0;
	for i in $(ls *.tar.gz 2>/dev/null); do save[$nb]=$i; let "nb+=1";done
	nb=0;	for i in "${save[@]}"; do echo $nb") Charger : $i"; let "n+=1";done
	echo "M) Menu";
	echo "Q) Quitter";
	read choice
		case "$choice" in
		        q|Q) exit;;
			m|M) menu;;
			0|1|2|3|4|5) clear; echo "Chargement en cours...";tar -xvvf ${save[$choice]} 1>/dev/null
				nb=0; while read ligne ; do perso[$nb]=$ligne; let "nb+=1";
				done < "$DEF_PATH"/char.txt
				cd "${perso[5]}"; clear; game "Partie chargée avec succès\n";;
		        *) echo "Choix non valide..."
		esac
	clear; menu
}

#Crée une nouvelle partie
function newchar {
	cd $DEF_PATH; clear;

	read -p "Quel est ton nom jeune aventurier? " nom ; clear
	read -p "Bienvenue, $nom, raconte moi ton histoire..." description ; clear
	pvmax=$((10 + ($RANDOM % 10)))
	pv=$pvmax
	echo -e "Je vois que tu as $pvmax PV.\n\nPour commencer ton aventure, choisi une arme dans la liste suivante:"
	echo -e Arme "\E[37;44m1\E[0m:"; cut -d: -f1,2 ./lib/armes.txt | sed -n '1p'
	echo -e Arme "\E[37;44m2\E[0m:"; cut -d: -f1,2 ./lib/armes.txt | sed -n '2p'
	echo -e Arme "\E[37;44m3\E[0m:"; cut -d: -f1,2 ./lib/armes.txt | sed -n '3p'
	echo -e "\033[0m"
	read -p 'Selectionnez le numéro de votre arme:
	' nbarme
        case "$nbarme" in
                q|Q) exit;;
		1|2|3)	char "$nom" "$description" "$pvmax" "$pv"
			sed -n $nbarme'p' ./lib/armes.txt >> char.txt
			start;;
                *) newchar;;
        esac
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

