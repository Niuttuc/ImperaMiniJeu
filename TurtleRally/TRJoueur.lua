print("LOAD joueur v1.09")
local liste={}
local ecran=config.ecran()

function config(couleur,nom,y)
	local data={
		couleur=couleur, -- couleur du joueur
		nom=nom, -- nom de la couleur
		actif=false, -- Passe sur true quand le joueur a rejoint
		vie=0, -- a 0 perdu
		coeur=0, -- a 0 perd une vie retour au dernier checkpoint
		position={x=x,y=y}, -- position actuel de la trutle
		direction="MY",
		checkpoint=0, -- 0 a 4 checkepoin en cours 0 pour départ
		fenetre={} -- stock toutes les fenetres
	}	
	data.ligne=window.create(ecran.pp,1,1,40,1,false)
	data.ligne.setBackgroundColor(couleur)
	data.ligne.clear()
	data.ligne.setTextColor(colors.white)
	data.ligne.setCursorPos(2,1)
	data.ligne.write(nom)
	
	data.affVie=window.create(data.ligne,10,1,8,1,true)
	data.affCoeur=window.create(data.ligne,18,1,11,1,true)
	
	table.insert(liste,data)
end
function actifs()
	local qte=0
	-- FONCTION NB JOUEUR ACTIF A CREE
	for idJoueur=1,#liste do
		if liste[idJoueur].actif then
			qte=qte+1
		end
	end
	return qte
end
function lancementGame()
	for idJoueur=1,#liste do
		if liste[idJoueur].actif then
			liste[idJoueur].vie=config.get("vie")
			actuVie(idJoueur)		
			liste[idJoueur].coeur=config.get("coeur")
			actuCoeurAff(idJoueur)
			joueur.affichage("all",{action="ATTENTE"})
		else
			joueur.affichage("all",{action="TOOLATE"})
		end
	end
end
function affichage(qui,quoi)
	if qui=='all' then
		for idJoueur=1,#liste do
			affichageJ(idJoueur,quoi)
		end
	else
		affichageJ(qui,quoi)
	end
end
function affichageJ(idJoueur,quoi)
	quoi.vie=liste[idJoueur].vie
	quoi.coeur=liste[idJoueur].coeur
	modem.transmit(liste[idJoueur].couleur+1,84,quoi)
end
function demandeChoix()
	affichage("all",{action="CHOIX"})
	local total=actifs()
	local retour={}
	while true end
		event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
		-- TROUVER ID JOUEUR
		
		liste[idJoueur].actions=message.actions -- ?? a confirmer
		retour[idJoueur]=message.actions
		total=total-1
	end
	return retour
end
function attenteInscription()
	while true end
		event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
		-- TROUVER ID JOUEUR
		
		if liste[idJoueur].actif then
			liste[idJoueur].actif=false	
			-- DEMANDE AFFICHAGE REGARDE ECRAN
		else
			liste[idJoueur].actif=true
			-- DEMANDE AFFICHAGE ECRAN POUR REJOINDRE
		end
		local cursY=2
		ecran.pp.clear()
		for idJoueur=1,#liste do
			if liste[idJoueur].actif then
				liste[idJoueur].ligne.reposition(1,cursY)
				liste[idJoueur].ligne.setVisible(true)
				cursY=cursY+1
			else
				liste[idJoueur].ligne.setVisible(false)
			end
		end	
	end
end
function present(x,y)
	for idJoueur=1,#liste do
		if liste[idJoueur].actif then
			if	x==liste[idJoueur].position.x and y==liste[idJoueur].position.y then
				return true
			end
		end
	end
	return false
end
function actuVie(i)
	if liste[i].vie==0 then liste[i].affVie.setBackgroundColor(colors.black)
	elseif liste[i].vie==1 then liste[i].affVie.setBackgroundColor(colors.red)
	elseif liste[i].vie==2 then liste[i].affVie.setBackgroundColor(colors.orange)
	else liste[i].affVie.setBackgroundColor(colors.green)	
	end
	liste[i].affVie.clear()
	liste[i].affVie.setCursorPos(2,1)
	if liste[i].vie==0 then liste[i].affVie.write("MORT")
	elseif liste[i].vie==1 then liste[i].affVie.write("1 vie")
	else
		liste[i].affVie.write(liste[i].vie.." vies")
	end	
end
function envie()
	if liste[i].coeur==0 then
		return false
	else
		return true
	end
end
function actuCoeurAff(i)
	liste[i].affCoeur.clear()
	liste[i].affCoeur.setCursorPos(2,1)
	liste[i].affCoeur.write(liste[i].coeur.." coeur")	
end
function tirageOrdre()
	local joueurTirage={}
	local retour={}
	local cursY=2
	
	for idJoueur=1,#liste do
		if liste[idJoueur].actif then
			table.insert(joueurTirage,idJoueur)
		end
	end
	
	for i=1, #joueurTirage do
		index=math.random(#joueurTirage)
		idJoueur=joueurTirage[index]		
		table.remove(joueurTirage,index)
		table.insert(idJoueur)
		liste[idJoueur].ligne.reposition(1,cursY)
		cursY=cursY+1
	end
	return retour
end
function tirageDepart()
	-- Tirage depart
	local joueurTirage={}
	for idJoueur=1,#liste do
		table.insert(joueurTirage,idJoueur)
	end
	
	local enAttente=0
	for idDepart=1, depart.total() do
		index=math.random(#joueurTirage)
		idJoueur=joueurTirage[index]
		local x, y=depart.def(idDepart,idJoueur,liste[idJoueur].couleur,liste[idJoueur].actif)
		liste[idJoueur].direction="MY"
		liste[idJoueur].position.x=x
		liste[idJoueur].position.y=y
		liste[idJoueur].idDepart=idDepart
		table.remove(joueurTirage,index)
		if liste[idJoueur].actif then
			modem.transmit(liste[idJoueur].couleur,84,{"onboard",{x=x,y=y}})
			enAttente=enAttente+1
		else
			modem.transmit(liste[idJoueur].couleur,84,"home")
		end
	end
	print("Attente de "..enAttente.." turtle")
	while enAttente~=0 do
		event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
		enAttente=enAttente-1
		print("Plus que "..enAttente)
	end
end