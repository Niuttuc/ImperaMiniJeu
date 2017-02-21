print("LOAD jeu v0.12")
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

local modem=config.modem()
modem.pp.open(84)

config.mapDef()
config.joueurDef()
config.affichageConf()


while true do
	
	joueur.affichage("all",{action="JOIN"})
	parallel.waitForAny(joueur.attenteInscription,affichage.attenteLancement)	
	
	joueur.lancementGame()	
	mur.reset()	
	bonus.tirageAll()
	etape.tirage()
	joueur.tirageDepart()
	
	
	
	while config.get("partie") do
		local ordre=joueur.tirageOrdre()
		local actions=joueur.demandeChoix()
		for tour=1, 5 do
			for i=1, #ordre do
				if config.get("partie") then
					idJoueur=ordre[i]
					joueur.afficherInfo(idJoueur,"T"..tour.." "..choices[actions[idJoueur][tour]].nomListe,colors.white)
					if joueur.envie() then
						if 
								actions[idJoueur][tour]=="clockTurn" 
							or  actions[idJoueur][tour]=="trigoTurn" 
							or  actions[idJoueur][tour]=="turnBack"  
						then -- Tourne droite
							joueur.tourne(idJoueur,actions[idJoueur][tour],tour)						
						else
							if actions[idJoueur][tour]=="avance2" then
								local enXfois=2
								actions[idJoueur][tour]="avance1"
							else 
								local enXfois=1
							end
							for minTour=1, enXfois do
								if enXfois==minTour then
									local dernier=true
								else
									local dernier=false
								end
								x,y=joueur.calculCoord(idJoueur,actions[idJoueur][tour])
								reussi=joueur.deplacement(idJoueur,x,y,tour,false,dernier)							
							end
							if reussi then
								joueur.afficherInfo(idJoueur,"T"..tour.." "..choices[actions[idJoueur][tour]].nomListe,colors.green)
								joueur.affichage(idJoueur,{action="infoTour",tour=tour,status=true})
							else
								joueur.afficherInfo(idJoueur,"T"..tour.." "..choices[actions[idJoueur][tour]].nomListe,colors.red)
								joueur.affichage(idJoueur,{action="infoTour",tour=tour,status=false})
							end
						end
					else
						joueur.affichage(idJoueur,{action="infoTour",status=false})
					end
				end
			end
		end
		joueur.retourAlavie(ordre)
	end
end