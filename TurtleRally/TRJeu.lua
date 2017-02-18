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
	game.partiePret=false
	while not(game.partiePret) do
		event, ecranN, xPos, yPos = os.pullEvent("monitor_touch")
		if joueur.actifs()>=2 then
			game.partiePret=true
		end
	end
end

while true do	
	-- DEMANDE AU POKCET AFFICHAGE JOIN
	joueur.affichage("all",{action="JOIN"})
	parallel.waitForAny(joueur.attenteInscription,attenteLancement)	
	
	joueur.lancementGame()
	mur.reset()
	bonus.tirageAll()
	etape.tirage()
	
	joueur.tirageDepart()
	
	while game.partiePret do
		local ordre=joueur.tirageOrdre()
		local actions=joueur.demandeChoix()
		for tour=1, 5 do
			for i=1, #ordre do
				idJoueur=ordre[i]
				if joueur.envie() then
					if 
							actions[idJoueur][tour]=="clockTurn" 
						or  actions[idJoueur][tour]=="trigoTurn" 
						or  actions[idJoueur][tour]=="turnBack"  
					then -- Tourne droite
						joueur.tourne(idJoueur,actions[idJoueur][tour])
					else
						-- COORD SI AVANT
						-- POSSIBLE ?
							-- AVANCER
							-- REACTION
					end
				end
			end
		end
	end
end