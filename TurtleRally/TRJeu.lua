print("LOAD jeu v0.10")
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
	while not(game.partiePret) do
		event, ecranN, xPos, yPos = os.pullEvent("monitor_touch")
		if joueur.actifs()>=2 then
			game.partiePret=true
		end
	end
end

while true do
	game.partiePret=false
	
	-- DEMANDE AU POKCET AFFICHAGE JOIN
	joueur.affichage("all",{action="JOIN"})
	parallel.waitForAny(joueur.attenteInscription,attenteLancement)	
	
	joueur.lancementGame()
	mur.reset()
	bonus.tirageAll()
	etape.tirage()


	-- Tirage depart
	for i=1, #game.depart do
		index=math.random(#joueurTirage)
		game.depart[i].idJoueur=joueurTirage[index]
		table.remove(joueurTirage,index)
		if joueurs[game.depart[i].idJoueur].actif then
			modem.transmit(42,84,{"paint",game.depart[i].nom,joueurs[game.depart[i].idJoueur].couleur})
			event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
		else
			modem.transmit(42,84,{"paint",game.depart[i].nom,colors.black})
			event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
		end	
	end
	enAttente=0
	for i=1, #game.depart do	
		if joueurs[game.depart[i].idJoueur].actif then
			modem.transmit(joueurs[game.depart[i].idJoueur].couleur,84,{"onboard",{x=game.depart[i].x,y=game.depart[i].y}})
			enAttente=enAttente+1
		else
			modem.transmit(joueurs[game.depart[i].idJoueur].couleur,84,"home")
		end	
	end
	print("Attente de "..enAttente.." turtle")
	while enAttente~=0 do
		event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
		enAttente=enAttente-1
		print("Plus que "..enAttente)
	end
	

for i=1,#joueurs do
	if joueurs[i].actif then
		joueurs[i].fenetre.ecranPrin.setVisible(false)
		joueurs[i].fenetre.bouton.setVisible(true)
		joueurs[i].fenetre.bouton.clear()
		
		for u=1, joueurs[i].coeur do
			joueurs[i].fenetre.bouton.setCursorPos(config.boutons[u].x+1,config.boutons[u].y)
			index=math.random(#cartes)
			joueurs[i].fenetre.bouton.write(cartes[index])			
		end
	end
end