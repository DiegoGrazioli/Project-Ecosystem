extends Node

var world_seconds
var world_minutes
var world_cycles

#Z-level order (dal basso all'alto): spore, piante, creature

#wait time
var wait_time = 1

#numero di esistenze nel gioco
var creatures = []
var spores = []
var plants = []

#tipi di esistenze
	#Carnide: si ciba di erbivori (Erbide e Pollinide)
	#Res Mante: si ciba di Carnide ma "ci mette molto a digerire" (dorme molto, AFK) e si riproduce poco spesso
	#Erbide: si ciba di foglie (Solaria, Vaniscenza e "Terminaria")
	#Pollinide: si ciba di piante
var poss_creatures = ["Carnide", "Res Mante", "Erbide", "Pollinide"]

	#Funghinoide: nasce da cadaveri. Buono!
	#Nerapeste: non succede, ma se succede: si attacca alle piante e contagia loro e chi li mangia (erbivori -> carnivori) UNICA SOLUZIONE ALL'EPIDEMIA è RES MANTE (il suo stomaco)
	#Simpianti: nascono ai piedi delle terminarie (simbiosi)
var poss_spores = ["Funghinoide", "Nerapeste", "Simpianti"]

	#Solaria: nasce a cazzo di cane grazie al SOLE! Si riproduce grazie al polline
	#Vaniscenza: nasce grazie ai funghi, si riproduce grazie al polline
	#Terminaria: nasce dai funghi, uccide erbivori per cibare i simpianti ai loro piedi 
var poss_plants = ["Solaria", "Vaniscenza", "Terminaria"]
