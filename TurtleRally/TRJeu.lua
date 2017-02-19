print("LOAD jeu v0.11")
os.loadAPI("ahb")
os.loadAPI("config")
os.loadAPI("joueur")
os.loadAPI("bonus")
os.loadAPI("mur")
os.loadAPI("etape")
os.loadAPI("depart")
os.loadAPI("map")

game={
	depart={},
	etapes={},
	partiePret=false,
	nbJoueurEnvie=false
}

local modem=config.modem()
modem.pp.open(84)

config.mapDef()
config.joueurDef()

function attenteLancement()
	config.set(partie,false)
	while not(config.get(partie)) do
		event, ecranN, xPos, yPos = os.pullEvent("monitor_touch")
		if joueur.actifs()>=2 then
			config.set(partie,true)
		end
	end
end

while true do	
	-- DEMANDE AU POKCET AFFICHAGE JOIN
	joueur.affichage("all",{action="JOIN"})
	parallel.waitForAny(joueur.attenteInscription,attenteLancement)	
	
	joueur.lancementGame()
	joueur.tirageDepart()
	mur.reset()	
	bonus.tirageAll()
	etape.tirage()
	
	
	
	while config.get(partie) do
		local ordre=joueur.tirageOrdre()
		local actions=joueur.demandeChoix()
		for tour=1, 5 do
			for i=1, #ordre do
				if config.get(partie) then
					idJoueur=ordre[i]
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
								x,y=joueur.calculCoord(idJoueur,actions[idJoueur][tour])
								reussi=joueur.deplacement(idJoueur,x,y,tour,false)							
							end
							if reussi then
								joueur.affichage(idJoueur,{action="infoTour",tour=tour,status=true})
							else
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