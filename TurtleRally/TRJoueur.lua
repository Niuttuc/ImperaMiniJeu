print("LOAD joueur v1.37")
local liste={}
local ecran=config.ecran()
local modem=config.modem()
local fenetre,taille=0
function configFenetre(fenetreC,tailleC)
	fenetre=fenetreC
	taille=tailleC
end
function configJ(couleur,nom,y)
	local data={
		couleur=couleur, -- couleur du joueur
		nom=nom, -- nom de la couleur
		actif=false, -- Passe sur true quand le joueur a rejoint,
		dodo=false,
		prochainDodo=false,
		vie=0, -- a 0 perdu
		coeur=0, -- a 0 perd une vie retour au dernier checkpoint
		position={x=x,y=y}, -- position actuel de la trutleq
		direction="MY",
		checkpoint=0, -- 0 a 4 checkepoin en cours 0 pour départ
		fenetre={}, -- stock toutes les fenetres
		actions={}
	}
	
	data.ligne=window.create(fenetre,1,1,taille,1,false)
	data.ligne.setBackgroundColor(couleur)
	data.ligne.clear()
	data.ligne.setTextColor(colors.white)
	data.ligne.setCursorPos(2,1)
	data.ligne.write(nom)
	
	data.affVie=window.create(data.ligne,10,1,8,1,true)
	data.affCoeur=window.create(data.ligne,19,1,11,1,true)
	data.affInfo=window.create(data.ligne,31,1,30,1,true)
	
	modem.pp.transmit(couleur,84,"home")
	
	
	table.insert(liste,data)
end
function tourne(idJoueur,action)
	if action=="clockTurn" then
		if liste[idJoueur].direction=="MY" then
			liste[idJoueur].direction="PX"
		elseif liste[idJoueur].direction=="PX" then
			liste[idJoueur].direction="PY"
		elseif liste[idJoueur].direction=="PY" then
			liste[idJoueur].direction="MX"
		elseif liste[idJoueur].direction=="MX" then
			liste[idJoueur].direction="MY"
		end
	elseif action=="trigoTurn" then
		if liste[idJoueur].direction=="MY" then
			liste[idJoueur].direction="MX"
		elseif liste[idJoueur].direction=="PX" then
			liste[idJoueur].direction="MY"
		elseif liste[idJoueur].direction=="PY" then
			liste[idJoueur].direction="PX"
		elseif liste[idJoueur].direction=="MX" then
			liste[idJoueur].direction="PY"
		end
	elseif action=="turnBack" then
		if liste[idJoueur].direction=="MY" then
			liste[idJoueur].direction="PY"
		elseif liste[idJoueur].direction=="PX" then
			liste[idJoueur].direction="MX"
		elseif liste[idJoueur].direction=="PY" then
			liste[idJoueur].direction="MY"
		elseif liste[idJoueur].direction=="MX" then
			liste[idJoueur].direction="PX"
		end
	end
	modem.pp.transmit(liste[idJoueur].couleur,84,action)
	local boucle=true
	while boucle do
		event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
		if liste[idJoueur].couleur==replyFrequency then
			boucle=false
		end
	end
end
function deplacement(idJoueur,x,y,pousseJoueur,mode)
	local reussi=true
	if liste[idJoueur].coeur~=0 then
		if present(x,y) then
			if pousseJoueur then
				local joueurPousser=joueur.trouver(x,y)
				local pousseReussi=deplacement(joueurPousser,x+(x-liste[idJoueur].position.x),y+(y-liste[idJoueur].position.y),false)
				if pousseReussi then
				else
					joueur.degat(joueurPousser)			
					return false, liste[idJoueur].coeur
				end
			else
				return false, liste[idJoueur].coeur
			end
		end
		local case=map.get(x,y)
		reussi=true
		reussi, ldegat=map.preAction(case,x,y)
		if not(ldegat==0) then
			joueur.degat(idJoueur)
		end
		if reussi then
			modem.pp.transmit(liste[idJoueur].couleur,84,{"bouge",{x=x,y=y}})
			local boucle=true
			while boucle do
				event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
				if liste[idJoueur].couleur==replyFrequency then
					boucle=false
				end
			end
			precX=liste[idJoueur].position.x
			precY=liste[idJoueur].position.y
			liste[idJoueur].position.x=x
			liste[idJoueur].position.y=y
			map.posteAction1(precX,precY,idJoueur)
			map.posteAction2(case,x,y,idJoueur)
		end
	else
		return false, liste[idJoueur].coeur
	end
	return reussi, liste[idJoueur].coeur
end
function tires()
	local calx=0
	local caly=0
	local case=''
	local boucle=true
	for idJoueur=1,#liste do
		if liste[idJoueur].actif then
			if not(liste[idJoueur].dodo) then
				if not(liste[idJoueur].coeur==0) then
					calx=liste[idJoueur].position.x
					caly=liste[idJoueur].position.y
					-- LANCER LE TIRE ICI
					boucle=true
					while boucle do
						calx,caly=calculPlusUn(calx,caly,liste[idJoueur].direction)
						if map.inmap(calx,caly) then
							toucher=presentGetId(calx,caly)
							if toucher==-1 then
								case=map.get(calx,caly)
								libre, ldegat=map.preAction(case,calx,caly) 
								if not(libre) then
									boucle=false
								end
							else
								joueur.degat(toucher)
								boucle=false
							end
						else
							boucle=false
						end
					end
					os.sleep(0.1)
				end
			end
		end
	end
	os.sleep(0.5)
end
function calculPlusUn(x,y,direction)
	if direction=="MY" then
		return x,y-1
	elseif direction=="PX" then
		return x+1,y
	elseif direction=="PY" then
		return x,y+1
	elseif direction=="MX" then
		return x-1,y
	end
end
function calculCoord(idJoueur,action)
	if action=="avance1" then
		return calculPlusUn(liste[idJoueur].position.x,liste[idJoueur].position.y,liste[idJoueur].direction)
	elseif action=="backUp" then
		if liste[idJoueur].direction=="MY" then
			return liste[idJoueur].position.x,liste[idJoueur].position.y+1
		elseif liste[idJoueur].direction=="PX" then
			return liste[idJoueur].position.x-1,liste[idJoueur].position.y
		elseif liste[idJoueur].direction=="PY" then
			return liste[idJoueur].position.x,liste[idJoueur].position.y-1
		elseif liste[idJoueur].direction=="MX" then
			return liste[idJoueur].position.x+1,liste[idJoueur].position.y
		end
	end
end
function actifs()
	local qte=0
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
			joueur.affichageTC(idJoueur,{action="WAIT"})
		else
			joueur.affichageTC(idJoueur,{action="TOOLATE"})
		end
	end
end
function renvoiLancementGame(couleur)
	for idJoueur=1,#liste do
		if liste[idJoueur].couleur==couleur then
			if liste[idJoueur].actif then
				joueur.affichageTC(idJoueur,{action="WAIT"})
			else
				joueur.affichageTC(idJoueur,{action="TOOLATE"})
			end
		end
	end
end
function affichageTCCouleur(couleur,quoi)
	for idJoueur=1,#liste do
		if liste[idJoueur].couleur==couleur then
			affichageTCJ(idJoueur,quoi)
		end
	end
end
function affichageTC(qui,quoi)
	if qui=='all' then
		for idJoueur=1,#liste do
			affichageTCJ(idJoueur,quoi)
		end
	else
		affichageTCJ(qui,quoi)
	end
end
function affichageTCJ(idJoueur,quoi)
	quoi.vie=liste[idJoueur].vie
	quoi.coeur=liste[idJoueur].coeur
	quoi.checkpoint=liste[idJoueur].checkpoint
	modem.pp.transmit(liste[idJoueur].couleur+1,84,quoi)
end
function trouver(x,y)
	for idJoueur=1,#liste do
		if liste[idJoueur].position.x==x and liste[idJoueur].position.y==y then
			return idJoueur
		end
	end
end
function afficherInfo(idJoueur,info,couleur)
	liste[idJoueur].affInfo.clear()
	liste[idJoueur].affInfo.setTextColor(couleur)
	liste[idJoueur].affInfo.setCursorPos(2,1)
	liste[idJoueur].affInfo.write(info)
end
function renvoiDemandeChoix(couleur)
	for idJoueurTemp=1,#liste do
		if liste[idJoueurTemp].couleur==couleur then
			idJoueur=idJoueurTemp
		end
	end
	if liste[idJoueur].actif then
		if #liste[idJoueur].actions==5 then
			affichageTC(idJoueur,{action="WAITPLAYER",actions=liste[idJoueur].actions})
		else
			if liste[idJoueur].dodo then
				affichageTC(idJoueur,{action="DODO",actions=liste[idJoueur].actions})
			else
				affichageTC(idJoueur,{action="CHOIX",actions=liste[idJoueur].precActions})
			end
		end
	else
		joueur.affichageTC(idJoueur,{action="TOOLATE"})
	end
end
function dodo(idJoueur)
	return liste[idJoueur].dodo
end
function demandeChoix()
	local total=0
	local retour={}
	local idJoueur=-1
	local nbPret=0
	for idJoueur=1, #liste do
		if liste[idJoueur].actif then
			if liste[idJoueur].prochainDodo then
				liste[idJoueur].dodo=true
				liste[idJoueur].prochainDodo=false
				affichageTC(idJoueur,{action="DODO",actions=liste[idJoueur].actions})
				afficherInfo(idJoueur,"Dort",colors.white)
			else
				total=total+1
				affichageTC(idJoueur,{action="CHOIX",actions=liste[idJoueur].actions})
				afficherInfo(idJoueur,"Choix en cours",colors.white)
				liste[idJoueur].precActions=liste[idJoueur].actions
				liste[idJoueur].actions={}
			end
		end
	end
	
	while not(total==nbPret) do
		event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
		if message~="JEFAITQUOI" then
			idJoueur=-1
			for idJoueurTemp=1,#liste do
				if liste[idJoueurTemp].couleur==replyFrequency-1 then
					idJoueur=idJoueurTemp
				end
			end
			if not(idJoueur==-1) then
				if type(message)=='table' then
					if #message.actions==5 then
						liste[idJoueur].actions=message.actions
						liste[idJoueur].prochainDodo=message.dodo
						retour[idJoueur]=message.actions
						afficherInfo(idJoueur,"PRET",colors.white)
						affichageTC(idJoueur,{action="WAITPLAYER",actions=liste[idJoueur].actions})
					end
				end
			end
			nbPret=0
			for idJoueurTemp=1,#liste do
				if liste[idJoueurTemp].actif and not(liste[idJoueurTemp].dodo) then
					if #liste[idJoueurTemp].actions==5 then
						nbPret=nbPret+1
					end
				end
			end
		end
	end
	return retour
end
function renvoiJoin(couleur)
	for idJoueur=1,#liste do
		if liste[idJoueur].couleur==couleur then
			if liste[idJoueur].actif then
				joueur.affichageTC(idJoueur,{action="LOBBY"})
			else 
				joueur.affichageTC(idJoueur,{action="JOIN"})
			end
		end
	end
end
function attenteInscription()
	local idJoueur=-1
	while true do		
		event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
		if message~="JEFAITQUOI" then
			for idJoueurTemp=1,#liste do
				if liste[idJoueurTemp].couleur==replyFrequency-1 then
					idJoueur=idJoueurTemp
				end
			end
			if idJoueur~=-1 then
				if liste[idJoueur].actif then
					liste[idJoueur].actif=false	
					joueur.affichageTC(idJoueur,{action="JOIN"})
				else
					liste[idJoueur].actif=true
					joueur.affichageTC(idJoueur,{action="LOBBY"})
				end
				local cursY=2
				fenetre.clear()
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
function presentGetId(x,y)
	for idJoueur=1,#liste do
		if liste[idJoueur].actif then
			if	x==liste[idJoueur].position.x and y==liste[idJoueur].position.y then
				return idJoueur
			end
		end
	end
	return -1
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
function envie(idJoueur)
	if liste[idJoueur].coeur==0 then
		return false
	else
		return true
	end
end
function retourAlavie(ordre)
	local enAttente=0
	local x,y=-1
	for i=1, #ordre do
		idJoueur=ordre[i]
		if liste[idJoueur].actif then
			if liste[idJoueur].coeur==0 then
				liste[idJoueur].dodo=false
				liste[idJoueur].prochainDodo=false
				liste[idJoueur].vie=liste[idJoueur].vie-1
				actuVie(idJoueur)
				if liste[idJoueur].vie==0 then
					affichageTC(idJoueur,{action="PERDU"})
					liste[idJoueur].actif=false
				else
					liste[idJoueur].coeur=config.get("coeur")
					actuCoeurAff(idJoueur)
					if liste[idJoueur].checkpoint==0 then
						x, y, orientation=depart.joueur(idJoueur)			
					else
						x, y, orientation=etape.coord(liste[idJoueur].checkpoint)
						if present(x,y) then
							x, y, orientation=depart.joueur(idJoueur)
						end
					end
					liste[idJoueur].position.x=x
					liste[idJoueur].position.y=y
					modem.pp.transmit(liste[idJoueur].couleur,84,{"onboard",{x=x,y=y}})
					liste[idJoueur].direction=orientation
					os.sleep(1)
					enAttente=enAttente+1
					liste[idJoueur].turtlePret=false
				end				
			else
				if liste[idJoueur].dodo then
					liste[idJoueur].dodo=false
					liste[idJoueur].prochainDodo=false
					liste[idJoueur].coeur=config.get("coeur")
					actuCoeurAff(idJoueur)
				end
			end
		end
	end
	while enAttente~=0 do
		enAttente=0
		event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
		if message~="JEFAITQUOI" then
			for idJoueur=1,#liste do
				if liste[idJoueur].actif then
					if replyFrequency==liste[idJoueur].couleur then
						liste[idJoueur].turtlePret=true
					end
					if not(liste[idJoueur].turtlePret) then						
						enAttente=enAttente+1
					end
				end				
			end
		end
	end
end
function actuCoeurAff(idJoueur)
	liste[idJoueur].affCoeur.clear()
	liste[idJoueur].affCoeur.setCursorPos(2,1)
	texte=liste[idJoueur].coeur.." coeur"
	if liste[idJoueur].coeur>1 then
		texte=texte.."s"
	end
	liste[idJoueur].affCoeur.write(texte)	
end
function heal(idJoueur)
	liste[idJoueur].coeur=liste[idJoueur].coeur+5
	if liste[idJoueur].coeur>10 then
		liste[idJoueur].coeur=10		
	end	
	actuCoeurAff(idJoueur)
	affichageTC(idJoueur,{action="INFO"})
end
function degatAll(idJoueurImu)
	local mini=0
	for idJoueur=1,#liste do
		if liste[idJoueur].actif then
			if idJoueur~=idJoueurImu then
				mini=math.min(mini,liste[idJoueur].checkpoint)
			end
		end
	end
	for idJoueur=1,#liste do
		if liste[idJoueur].actif then
			if idJoueur~=idJoueurImu then
				degats=1+((liste[idJoueur].checkpoint-mini)*3)
				if degats>=liste[idJoueur].coeur then
					degats=liste[idJoueur].coeur-2
				end
				joueur.degat(idJoueur,degats)
			end
		end
	end
end
function degat(idJoueur,cb)
	if cb==nil then
		cb=1
	end
	if cb<0 then
		cb=0
	end
	liste[idJoueur].coeur=liste[idJoueur].coeur-cb
	if liste[idJoueur].coeur<0 then liste[idJoueur].coeur=0 end
	if liste[idJoueur].coeur==0 then
		mort(idJoueur)
	else
		actuCoeurAff(idJoueur)
		affichageTC(idJoueur,{action="INFO"})
	end	
end
function mort(idJoueur)
	liste[idJoueur].coeur=0
	actuCoeurAff(idJoueur)
	liste[idJoueur].position.x=-1
	liste[idJoueur].position.y=-1
	affichageTC(idJoueur,{action="INFO"})
	modem.pp.transmit(liste[idJoueur].couleur,84,{"mort"})
	local boucle=true
	while boucle do
		event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
		if liste[idJoueur].couleur==replyFrequency then
			boucle=false
		end
	end
end
function tirageOrdre()
	local joueurTirage={}
	local cursY=2
	local retour={}
	for idJoueur=1,#liste do
		if liste[idJoueur].actif then
			table.insert(joueurTirage,idJoueur)
		end
	end
	ecran.pp.clear()
	for i=1, #joueurTirage do
		index=math.random(#joueurTirage)
		idJoueur=joueurTirage[index]
		table.insert(retour,idJoueur)
		table.remove(joueurTirage,index)		
		liste[idJoueur].ligne.reposition(1,cursY)
		cursY=cursY+1
	end
	return retour
end
function passageEtape(idJoueur,numero)
	if liste[idJoueur].checkpoint==numero-1 then
		liste[idJoueur].checkpoint=numero
	end
	if liste[idJoueur].checkpoint==config.get("etape") then
		affichageTC(idJoueur,{action="GAGNER"})
		config.set("partie",false)
	end
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
		local x, y, orientation=depart.def(idDepart,idJoueur,liste[idJoueur].couleur,liste[idJoueur].actif)
		liste[idJoueur].direction=orientation
		liste[idJoueur].position.x=x
		liste[idJoueur].position.y=y
		liste[idJoueur].idDepart=idDepart
		liste[idJoueur].checkpoint=0
		table.remove(joueurTirage,index)
		if liste[idJoueur].actif then
			modem.pp.transmit(liste[idJoueur].couleur,84,{"onboard",{x=x,y=y}})
			enAttente=enAttente+1
			liste[idJoueur].turtlePret=false
		else
			modem.pp.transmit(liste[idJoueur].couleur,84,"home")
		end
	end
	while enAttente~=0 do
		enAttente=0
		event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
		if message~="JEFAITQUOI" then
			for idJoueur=1,#liste do
				if liste[idJoueur].actif then
					if replyFrequency==liste[idJoueur].couleur then
						liste[idJoueur].turtlePret=true
					end
					if not(liste[idJoueur].turtlePret) then						
						enAttente=enAttente+1
					end
				end				
			end
		end
	end
end