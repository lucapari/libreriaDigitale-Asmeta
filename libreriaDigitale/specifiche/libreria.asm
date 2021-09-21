asm libreria

import StandardLibrary


signature:

//Domains
	enum domain SceltaUtente = {NOLEGGIARE|RESTITUIRE}
	enum domain ArticoloLibreria={LIBRO|AUDIO|RIVISTA}
	//ArticoloID = ID da 1 a 3 che identifica un articolo specifico
	domain ArticoloID subsetof Integer 

//Functions
	//valori immessi dall'utente
	monitored sceltaAzione : SceltaUtente
	monitored sceltaArticolo : ArticoloLibreria
	monitored sceltaID : ArticoloID
	//funzione che restituisce se un determinato articolo è disponibile per il noleggio o no
	controlled disponibile : Prod(ArticoloLibreria, ArticoloID) -> Boolean
	//funzione statica che restituisce informazioni sull'articolo. Il risultato prodotto
	//dalla funzione verrà salvato in "infoArticolo"
	static getInfoArticolo : Prod(ArticoloLibreria, ArticoloID) -> String
	out infoArticolo : String
	//messaggio restituito all'utente
	out messUtente : String
	
	
definitions:
	domain ArticoloID = {1:3}
	
	function getInfoArticolo($artName in ArticoloLibreria, $artID in ArticoloID) =
	 switch($artName, $artID)
	 	case (LIBRO, 1):
	 		"LIBRO - I Malavoglia"
	 	case (LIBRO, 2):
	 		"LIBRO - Anna Karenina"
	 	case (LIBRO, 3):
	 		"LIBRO - Fosca"
	 	case(AUDIO,1):
	 		"AUDIO - The best of Vivaldi"
	 	case(AUDIO,2):
	 		"AUDIO - West End Blues"
	 	case(AUDIO,3):
	 		"AUDIO - Beethoven Piano Concert"
	 	case(RIVISTA,1):
	 		"RIVISTA - Wired"
	 	case(RIVISTA,2):
	 		"RIVISTA - Focus"
	 	case(RIVISTA,3):
	 		"RIVISTA - Times"
	 endswitch	
	
	rule r_noleggia($artName in ArticoloLibreria, $artID in ArticoloID) =
		if(disponibile($artName, $artID) = true) then
			par
			disponibile($artName, $artID) := false
			messUtente := "Articolo noleggiato correttamente."
			infoArticolo := getInfoArticolo($artName, $artID)
			endpar
		else
			par
			messUtente := "Errore. L'articolo non e' disponibile per il noleggio."
			infoArticolo := getInfoArticolo($artName, $artID)
			endpar
		endif
		
	rule r_restituisci($artName in ArticoloLibreria, $artID in ArticoloID) =
	if(disponibile($artName, $artID) = false) then
			par
			disponibile($artName, $artID) := true
			messUtente := "Articolo restituito correttamente."
			infoArticolo := getInfoArticolo($artName, $artID)
			endpar
		else
			par
			messUtente := "Errore. L'articolo e' gia' stato restituito."
			infoArticolo := getInfoArticolo($artName, $artID)
			endpar
		endif

	main rule r_Main =
		switch(sceltaAzione)
			case NOLEGGIARE:
				switch(sceltaArticolo)
					
					case LIBRO:
						switch(sceltaID)
							case 1:
								r_noleggia[LIBRO, 1]
							case 2:
								r_noleggia[LIBRO, 2]
							case 3:
								r_noleggia[LIBRO, 3]
						endswitch
						
					case AUDIO:
						switch(sceltaID)
							case 1:
								r_noleggia[AUDIO, 1]
							case 2:
								r_noleggia[AUDIO, 2]
							case 3:
								r_noleggia[AUDIO, 3]
						endswitch
						
					case RIVISTA:
						switch(sceltaID)
							case 1:
								r_noleggia[RIVISTA, 1]
							case 2:
								r_noleggia[RIVISTA, 2]
							case 3:
								r_noleggia[RIVISTA, 3]
						endswitch
						
				endswitch
			
			case RESTITUIRE:
			
			switch(sceltaArticolo)
					
					case LIBRO:
						switch(sceltaID)
							case 1:
								r_restituisci[LIBRO, 1]
							case 2:
								r_restituisci[LIBRO, 2]
							case 3:
								r_restituisci[LIBRO, 3]
						endswitch
						
					case AUDIO:
						switch(sceltaID)
							case 1:
								r_restituisci[AUDIO, 1]
							case 2:
								r_restituisci[AUDIO, 2]
							case 3:
								r_restituisci[AUDIO, 3]
						endswitch
						
					case RIVISTA:
						switch(sceltaID)
							case 1:
								r_restituisci[RIVISTA, 1]
							case 2:
								r_restituisci[RIVISTA, 2]
							case 3:
								r_restituisci[RIVISTA, 3]
						endswitch
						
				endswitch
				
		endswitch
		
default init s0:
function disponibile($artName in ArticoloLibreria, $artID in ArticoloID) = true