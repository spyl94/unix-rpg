#Déplace le personnage dans la pièce reçue en paramètre
function move {
	clear
	if [ "${pieces[$1]}" ]; then cd "${perso[5]}/${pieces[$1]}";
	else echo "Cette pièce n'éxiste pas"; fi
}

#Fait combattre le personnage avec le mob reçu en paramètre
function fight {
	clear
	nomMob=$(echo ${mobs[$1]} | cut -d: -f1)
	desMob=$(echo ${mobs[$1]} | cut -d: -f2)
	declare -i pvMob=$(echo ${mobs[$1]} | cut -d: -f3)
	declare -i degMaxMob=$(echo ${mobs[$1]} | cut -d: -f4)
	echo -e "Vous entrez en phase de combat avec: $nomMob,\n$desMob";
	while [ "$pvMob" -gt 0 ]; do
		echo -e "Vos Pv: \e[1;33m$pv\e[0m | $nomMob Pv: \e[1;33m$pvMob\e[0m"
		if [ $(($RANDOM%2)) -eq 0 ]; then ((pvMob-=$degArme)); echo -e "	\e[1;32mVous infligez \e[1;33m$degArme\e[1;32m dommages.\e[0m";
		else echo "	Vous ratez votre attaque..."; fi
		sleep 1;
		if [ $pvMob -gt 0 ]; then
			if [ $(($RANDOM%3)) -eq 0 ]; then ((pv-=$degMaxMob)); echo -e "	\e[1;31m$nomMob vous inflige \e[1;33m$degMaxMob\e[1;31m dommages.\e[0m";
			else echo -e "	$nomMob rate son attaque!"; fi
			sleep 1;
		fi
		if [ $pv -le 0 ]; then clear; echo "Vous êtes mort... $nomMob vous a vaincu."; rm -rf $DEF_PATH/char.txt; menu; fi
	done
	sed $(($1+1))"d" `pwd`/mobs.txt -i
	clear; echo -e "\e[1;34mVous avez vaincu $nomMob !\e[0m"
}

#Fait résoudre au personnage l'énigme reçue en paramètre
function resolve {
	clear
	echo "${enigmes[$1]}?" | cut -d: -f2
	echo -n "1)"; echo "${enigmes[$1]}?" | cut -d: -f3
	echo -n "2)"; echo "${enigmes[$1]}?" | cut -d: -f4
	echo "A) Annuler"
	echo "Q) Quitter"
	read choice
	case "$choice" in
                q|Q) exit;;
		a|A) game;;
		1|2) let "choice+=2";	if [ $(echo "${enigmes[$1]}" | cut -d: -f$(($choice))) = $(echo "${enigmes[$1]}" | cut -d: -f5) ]; then
				sed $(($1+1))"d" `pwd`/enigmes.txt -i; clear; game "Félicitations, vous avez réussi l'énigme!\n";
			else	
				clear; echo "Vous avez ratez l'énigme et perdez 3PV."; ((pv-=3));
				if [ $pv -le 0 ]; then clear; echo "Vous êtes mort... $nomMob vous a vaincu."; rm -rf $DEF_PATH/char.txt; menu; fi
			fi;;
                *) echo "Choix non valide..."
        esac	
}

function choice { if [ ! $mobsCount -eq 0 ]; then fight $1; elif [ ! $enigmesCount -eq 0 ]; then resolve $1; else move $1; fi }

#Utilise le passage secret si il est disponible
function secret {
	if [ $(ls -F | grep @ -c) -eq 0 ]; then clear; echo "Il n'y a pas de passage secret ici.";
	else clear; echo "Vous avez trouvé un passage secret, il semble mener vers " $(ls -F | grep @ | cut -d@ -f1)".";
	echo -e "Osez vous l'emprunter?\nO)Oui\nN)Non"
	read choice
	case "$choice" in
                q|Q) quitter;;
		o|O) cd $(ls -F | grep @ | cut -d@ -f1);;
		n|N) break;;
                *) echo "Choix non valide..."
        esac
	fi
}

#Retourne dans la pièce précédente
function reculer {
	if [ "$lieu" != "entree" ]; then cd ..; clear;
	else clear; echo "Vous ne pouvez pas reculer..."; fi
}

#Fait boire au personnage la potion reçue en paramètre
function drink {
	pvSup=$(echo ${potions[$1]} | cut -d: -f3)
	let "pv+=pvSup"
	[ $pv -gt $pvMax ] && ((pv=$pvMax));
	clear; echo -e "\e[1;34mVous avez utilisé la potion: ${potions[$1]}.\e[0m" | cut -d: -f1,2
	sed $(($1+1))"d" `pwd`/potions.txt -i
}

#Liste les potions disponibles
function potion {
	clear; nb=0
	echo "Potion(s) Disponible(s):"
	for i in "${potions[@]}"; do 
		echo "-$i" | cut -d: -f1; 
		echo "$i" | cut -d: -f2;
		let "nb+=1"; 
	done; nb=0;
	if [ ! $potionsCount -eq 0 ]; then
		for i in "${potions[@]}"; do echo $nb") Utiliser : $i" | cut -d: -f1,2; let "nb+=1"; done;
		echo "A) Annuler"
		echo "Q) Quitter"
		read choice 
		case "$choice" in
		        q|Q) quitter;;
			a|A) game;;
			0|1|2|3|4|5) drink $choice;;
		        *) echo "Choix non valide..."
		esac
	else	echo "Vous ne trouvez aucune potion dans la pièce..."; fi
}

#Echange l'arme du personnage
function switch {
	if [ "${armes[$1]}" ]; then
		clear;
		sed $(($1+1))"d" `pwd`/armes.txt -i
		char "${perso[0]}" "${perso[1]}" "${perso[2]}" "$pv" "${armes[$1]}" `pwd`
		echo "Vous êtes désormais équipé d'une nouvelle arme."; game
	else clear; echo "Choix non valide..."; fi; 
}

#Liste les armes disponibles
function armes {
	clear; nb=0
	if [ ! $armesCount -eq 0 ]; then
		echo "Arme(s) Disponible(s):"
		for i in "${armes[@]}"; do 
			echo "-$i" | cut -d: -f1; 
			echo "$i" | cut -d: -f2;
			let "nb+=1"; 
		done; nb=0;
		for i in "${armes[@]}"; do echo $nb") Equiper : $i" | cut -d: -f1,2; let "nb+=1"; done;
		echo "A) Annuler"
		echo "Q) Quitter"
		read choice 
		case "$choice" in
		        q|Q) quitter;;
			a|A) game;;
			0|1|2|3|4|5) switch $choice;;
		        *) clear; echo "Choix non valide..."
		esac
	else	echo "Vous ne trouvez aucune arme dans la pièce..."; fi
}
