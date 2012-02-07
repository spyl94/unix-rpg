#Place les objets dans les salles
function initObjects {
	touch $1/armes.txt $1/enigmes.txt $1/mobs.txt $1/potions.txt $1/enigmes.txt $1/description.txt #inutile mais demandé par l'énoncé.
	if [ $(($RANDOM%2)) -eq 0 ]; then
		echo $(sed -n $((1 + ($RANDOM % 11)))"p" $DEF_PATH"/lib/armes.txt") >> $1/armes.txt;
		((nombreArmes++))
	fi
	if [ $(($RANDOM%2)) -eq 0 ]; then
 		echo $(sed -n $((1 + ($RANDOM % 13)))"p" $DEF_PATH"/lib/mobs.txt") >> $1/mobs.txt;
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
	echo $(sed -n $((1 + ($RANDOM % 2)))"p" $DEF_PATH"/lib/description.txt") > $1/description.txt;
}

#Crée la carte du jeu
function initPlacement {
	find "$DEF_PATH/entree" -type d | (while read A ; do initObjects $A; done
	if [[ "$nombreMobs" -gt 12 && "$nombreEnigmes" -gt 8 ]]; then echo "Génération de la carte terminée."; else initPlacement; fi
	)
}

#Initialise la carte
function initMap {
	rm -Rf $DEF_PATH/entree
	mkdir -p $DEF_PATH/entree/{hall/{chambre/{armoire,bibliotheque},cuisine/{coin,garde_manger/abattoir},salon/{cheminee,etage},escalier/{cave,crypte}},jardin/{cabane,allee/foret/{grotte,champignonniere}}}
	if [ $? != 0 ]; then echo "Impossible de créer la carte."; exit; fi

	#sortie:
	rand=$((3 + ($RANDOM % 15 )));
	find "$DEF_PATH/entree" -type d | while read A ; do 
	let "cpt+=1"; if [ $rand -eq $cpt ]; then mkdir $A/sortie; fi
	done


	#passages secrets:
	ln -s $DEF_PATH/entree/hall/salon/cheminee/ $DEF_PATH/entree/jardin/cabane

	nombreMobs=0;
	nombreEnigmes=0;
	nombreArmes=0;
	nombrePotions=0;
	initPlacement
}

#Initialise la partie
function start {
	initMap
	cd entree
	pwd >> "$DEF_PATH"/char.txt
	clear
	game
}
