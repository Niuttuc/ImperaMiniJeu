print("LOAD jeu v0.23")
os.loadAPI("ahb")
os.loadAPI("config")
os.loadAPI("joueur")
os.loadAPI("bonus")
os.loadAPI("mur")
os.loadAPI("etape")
os.loadAPI("depart")
os.loadAPI("map")
os.loadAPI("affichage")
os.loadAPI('choices')
os.loadAPI("laser")


local modem=config.modem()
modem.pp.open(84)

config.mapDef()
config.joueurDef()
config.affichageConf()

joueur.retourHomeAll()

function ecoute()
	while true do
		event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")		
		if message=="JEFAITQUOI" then
			if config.get("etapeTelecommande")=="JOIN" then
				joueur.renvoiJoin(replyFrequency-1)
				--joueur.affichageCouleur(replyFrequency-1,{action="JOIN"})
			elseif config.get("etapeTelecommande")=="WAIT" then
				joueur.renvoiLancementGame(replyFrequency-1)
			elseif config.get("etapeTelecommande")=="CHOIX" then
				joueur.renvoiDemandeChoix(replyFrequency-1)
			elseif config.get("etapeTelecommande")=="TOUR" then
				joueur.renvoiDemandeChoix(replyFrequency-1)
			end
		end
	end
end
actions={}
function jeu()
	while true do
		
		config.set("etapeTelecommande","JOIN")
		joueur.affichageTC("all",{action="JOIN"})
		parallel.waitForAny(joueur.attenteInscription,affichage.attenteLancement)	
		config.set("etapeTelecommande","WAIT")
		joueur.lancementGame()	
		mur.reset()	
		bonus.tirageAll()
		etape.tirage()
		joueur.tirageDepart()
		
		while config.get("partie") do
			print("===============================")
			local ordre=joueur.tirageOrdre()
			config.set("etapeTelecommande","CHOIX")
			actions=joueur.demandeChoix()
			config.set("etapeTelecommande","TOUR")
			
			--print("Action TOUTES RECU")
			for tour=1, 5 do
				--print("==== Tour "..tour.." "..tostring(config.get("partie")))
				for i=1, #ordre do
					if config.get("partie") then
						idJoueur=ordre[i]
						if not(joueur.dodo(idJoueur)) then
							if joueur.envie(idJoueur) then
								joueur.afficherInfo(idJoueur,"T"..tour.." "..choices[actions[idJoueur][tour]].nomListe,colors.white)
								if 
										actions[idJoueur][tour]=="clockTurn" 
									or  actions[idJoueur][tour]=="trigoTurn" 
									or  actions[idJoueur][tour]=="turnBack"  
								then -- Tourne droite
									joueur.tourne(idJoueur,actions[idJoueur][tour])
									joueur.affichageTC(idJoueur,{action="infoTour",tour=tour,status=true})								
								else
									if actions[idJoueur][tour]=="avance2" then
										x,y=joueur.calculCoord(idJoueur,"avance1")
										reussi, coeurs=joueur.deplacement(idJoueur,x,y,true)
										x,y=joueur.calculCoord(idJoueur,"avance1")
										reussi, coeurs=joueur.deplacement(idJoueur,x,y,true)
									else 
										x,y=joueur.calculCoord(idJoueur,actions[idJoueur][tour])
										reussi, coeurs=joueur.deplacement(idJoueur,x,y,true)
									end
									local infoEnPlus=""
									if coeurs==0 then
										infoEnPlus=" MORT"
									end
									--print(reussi)
									if reussi then
										joueur.afficherInfo(idJoueur,"Tour "..tour.." "..choices[actions[idJoueur][tour]].nomListe..infoEnPlus,colors.green)
										joueur.affichageTC(idJoueur,{action="infoTour",tour=tour,status=true})
									else
										joueur.afficherInfo(idJoueur,"Tour "..tour.." "..choices[actions[idJoueur][tour]].nomListe..infoEnPlus,colors.red)
										joueur.affichageTC(idJoueur,{action="infoTour",tour=tour,status=false})
									end
									
								end
								os.sleep(0.8)
							else
								joueur.affichageTC(idJoueur,{action="infoTour",tour=tour,status=false})
							end
						end
					end
				end
				if config.get("partie") then
					--print("  ACTION TAPIS, PLAQUE, TIR ;)")
					map.actionTapis()
					laser.tires()
					os.sleep(0.7)
					joueur.tires()
					
				end
			end
			if config.get("partie") then
				--print("  RETOUR A LA VIE")
				joueur.retourAlavie(ordre)
			else
				os.sleep(1)
			end
		end
		joueur.retourHomeAll()
	end	
end
parallel.waitForAll(jeu,ecoute)