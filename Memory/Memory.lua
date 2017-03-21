local affichage={} -- selecteurs pour l'affichage
local coffres={} -- coffres contenant les items
local joueur={}
local nbSelecteurParJoueur=8
local nbSelecteurParMoniteur={8,8}
local configFenetre={
	{10,10,10,11,10,11,10,10},
	{10,10,10,11,10,11,10,10}
}
local coteRedstone="back"

function addPeripheral(id)
	if not(peripheral.isPresent(id)) then
		print(id..' non connecte')
	end
	return {
		id=id,
		pp=peripheral.wrap(id)
	}
end
function cacheEcran()
	total=0
	for ij=1,#joueur do
		if joueur[ij].cache then
			total=total+joueur[ij].couleur
		end
	end
	redstone.setBundledOutput(coteRedstone,total)
end

local moniteurModjeu=addPeripheral("top")
local fenetreModjeu=window.create(moniteurModjeu.pp,1,1,20,5)
fenetreModjeu.setCursorPos(6,2)
fenetreModjeu.write("Scorring")
fenetreModjeu.setCursorPos(7,4)
fenetreModjeu.write("Versus")

local fenetreDifficulte=window.create(moniteurModjeu.pp,1,1,20,5,false)
fenetreDifficulte.setCursorPos(4,1)
fenetreDifficulte.write("Rouge et blanc")
fenetreDifficulte.setCursorPos(7,3)
fenetreDifficulte.write((nbSelecteurParJoueur*4).." items")
fenetreDifficulte.setCursorPos(7,5)
fenetreDifficulte.write((nbSelecteurParJoueur*9).." items")

local fenetreExplication=window.create(moniteurModjeu.pp,1,1,40,5,false)
fenetreExplication.setCursorPos(1,2)
fenetreExplication.write("Cliquer sur la laine grise pour rejoindre")
fenetreExplication.setCursorPos(1,3)
fenetreExplication.write("Quand tous les joueurs on rejoind")
fenetreExplication.setCursorPos(1,4)
fenetreExplication.write("Tous le monde clique sur la laine verte")

local fenetreEncours=window.create(moniteurModjeu.pp,1,1,20,5,false)
fenetreEncours.setCursorPos(1,3)
fenetreEncours.write("Partie en cours")


function addAffichage(id)
	table.insert(affichage,addPeripheral('openperipheral_selector_'..id))
end
addAffichage(1)
addAffichage(2)
addAffichage(3)
addAffichage(4)
addAffichage(5)
addAffichage(6)
addAffichage(7)
addAffichage(8)
addAffichage(9)
addAffichage(10)
addAffichage(11)
addAffichage(12)
addAffichage(13)
addAffichage(14)
addAffichage(15)
addAffichage(16)
function addCoffre(id)
	table.insert(coffres,addPeripheral(id))
end
addCoffre('stock_chest_0')
addCoffre('stock_chest_1')
addCoffre('stock_chest_2')

function addJoueur(couleur,selecteurs,moniteurs)
	if #selecteurs~=nbSelecteurParJoueur then
		print("Nombre de selecteur pour le joueur "..(#joueur+1).." invalide ("..#selecteurs.."/"..nbSelecteurParJoueur)
	end
	if #moniteurs~=math.ceil(#affichage/8) then
		print("Nombre d'ecran pour le joueur "..(#joueur+1).." invalide "..#moniteurs.."/"..math.ceil(#affichage/8))
	end
	local data={
		couleur=couleur,
		actif=true,
		cache=true,
		selecteurs={},
		moniteurs={},
		fenetres={}
	}
	for i=1,#selecteurs do
		table.insert(data.selecteurs,addPeripheral(selecteurs[i]))
	end
	for i=1,#moniteurs do
		table.insert(data.moniteurs,addPeripheral(moniteurs[i]))		
		local posX=1
		for u=1,nbSelecteurParMoniteur[i] do
			fenetre=window.create(data.moniteurs[i].pp,posX,1,configFenetre[i][u],5)			
			posX=posX+configFenetre[i][u]
			fenetre.setBackgroundColour(couleur)
			fenetre.clear()
			table.insert(data.fenetres,fenetre)
		end
	end
	data.fenetreResultat=window.create(data.moniteurs[1].pp,3,1,8,5,false)
	table.insert(joueur,data)
end
addJoueur(colors.orange,{
	'openperipheral_selector_34',
	'openperipheral_selector_33',
	'openperipheral_selector_35',
	'openperipheral_selector_36',
	'openperipheral_selector_37',
	'openperipheral_selector_38',
	'openperipheral_selector_39',
	'openperipheral_selector_40'
},{
	'monitor_13',
	'monitor_14'
})
addJoueur(colors.cyan,{
	'openperipheral_selector_41',
	'openperipheral_selector_42',
	'openperipheral_selector_43',
	'openperipheral_selector_44',
	'openperipheral_selector_45',
	'openperipheral_selector_46',
	'openperipheral_selector_47',
	'openperipheral_selector_48'
},{
	'monitor_10',
	'monitor_11'
})
addJoueur(colors.blue,{
	'openperipheral_selector_49',
	'openperipheral_selector_50',
	'openperipheral_selector_51',
	'openperipheral_selector_52',
	'openperipheral_selector_53',
	'openperipheral_selector_54',
	'openperipheral_selector_55',
	'openperipheral_selector_56'
},{
	'monitor_8',
	'monitor_9'
})
addJoueur(colors.yellow,{
	'openperipheral_selector_57',
	'openperipheral_selector_58',
	'openperipheral_selector_59',
	'openperipheral_selector_60',
	'openperipheral_selector_61',
	'openperipheral_selector_62',
	'openperipheral_selector_63',
	'openperipheral_selector_64'
},{
	'monitor_15',
	'monitor_16'
})
cacheEcran()

function afficherSequence(idCoffre,nbItem)
	coffres[idCoffre].pp.condenseItems()
	local stacks=coffres[idCoffre].pp.getAllStacks()
	local resultatSlot={}
	local resultat={}
	local multiItem=true
	if nbItem>#stacks then
		multiItem=true
		for i=1, nbItem do 
			resultatSlot[i]=math.random(#stacks)
		end
	else
		multiItem=false
		local preRand={}
		local rand=0
		for i=1, #stacks do
			preRand[i]=i
		end
		for i=1, nbItem do 
			rand=math.random(#preRand)
			resultatSlot[i]=preRand[rand]
			table.remove(preRand,rand)
		end
	end
	local premierSelect=math.floor(((#affichage-nbItem)/2))
	afficheMonitorSequence(premierSelect,nbItem,false)
	for i=1, nbItem do
		resultat[i]=stacks[resultatSlot[i]].all()
		affichage[i+premierSelect].pp.setSlot(1,resultat[i])
	end
	return resultat, premierSelect, multiItem
end
function affichageClean()
	for i=1, #affichage do
		affichage[i].pp.setSlot(1)
	end
end
function cleanSelecteurJoueur(idJoueur)
	for is=1,nbSelecteurParJoueur do
		joueur[idJoueur].selecteurs[is].pp.setSlots({})
	end
end
function cleanSelecteurJoueurs()
	for ij=1,#joueur do
		cleanSelecteurJoueur(ij)
	end
end

function afficherSelecteurJoueur(idCoffre)
	coffres[idCoffre].pp.condenseItems()
	local stacks=coffres[idCoffre].pp.getAllStacks()
	local parEcran=9
	if #stacks<=nbSelecteurParJoueur then
		parEcran=1
	elseif #stacks<=nbSelecteurParJoueur*4 then
		parEcran=4
	elseif #stacks<=nbSelecteurParJoueur*9 then
		parEcran=9
	else
		print('TROP ITEMS POUR TOUS AFFICHER')
	end
	for ij=1,#joueur do
		if joueur[ij].actif then
			stacks=coffres[idCoffre].pp.getAllStacks()
			for is=1,nbSelecteurParJoueur do
				joueur[ij].numerique[is]={}
				joueur[ij].numeriqueOk[is]={}
				for isl=1, parEcran do
					if #stacks~=0 then
						if parEcran==4 and isl>2 then
							isl=isl+1
						end
						joueur[ij].numerique[is][isl]=stacks[1].all()
						joueur[ij].numeriqueOk[is][isl]=true
						joueur[ij].selecteurs[is].pp.setSlot(isl,joueur[ij].numerique[is][isl])
						table.remove(stacks,1)
					end
				end
			end
		end
	end
end
function fenetreColorisation(idJoueur,idFenetre,couleur)
	joueur[idJoueur].fenetres[idFenetre].setBackgroundColour(couleur)
	joueur[idJoueur].fenetres[idFenetre].clear()
end
function afficheMonitorSequence(premierSelect,sequenceNB,marquerPremier)
	for ij=1,#joueur do
		if joueur[ij].actif then			
			for ife=1, #joueur[ij].fenetres do
				if ife<=premierSelect or premierSelect+sequenceNB<ife then
					fenetreColorisation(ij,ife,colors.black)
				elseif ife==premierSelect+1 then
					if marquerPremier then
						fenetreColorisation(ij,ife,joueur[ij].couleur)
					else
						fenetreColorisation(ij,ife,colors.white)
					end
				else 
					fenetreColorisation(ij,ife,colors.white)
				end
			end
		end
	end
end
function ecouteJoueur(sequenceNB,premierSelect,multiItem)
	afficheMonitorSequence(premierSelect,sequenceNB,true)
	for ij=1,#joueur do
		if joueur[ij].actif then
			joueur[ij].sequence={}
			joueur[ij].cache=false
		end
	end
	cacheEcran()
	local fini=false
	while not(fini) do		
		event, slot, side = os.pullEvent('slot_click')
		fini=true
		for ij=1,#joueur do
			if joueur[ij].actif then				
				for is=1,nbSelecteurParJoueur do
					if joueur[ij].selecteurs[is].id==side then
						print('Event joueur '..ij)
						if #joueur[ij].sequence<sequenceNB then
							table.insert(joueur[ij].sequence,joueur[ij].selecteurs[is].pp.getSlot(slot))
							fenetreColorisation(ij,premierSelect+#joueur[ij].sequence,colors.brown)
							if not(multiItem) then
								joueur[ij].selecteurs[is].pp.setSlot(slot)
								joueur[ij].numeriqueOk[is][slot]=false
							end
						end
						if #joueur[ij].sequence==sequenceNB then							
							joueur[ij].cache=true
							cacheEcran()
						else
							fenetreColorisation(ij,premierSelect+#joueur[ij].sequence+1,joueur[ij].couleur)
						end
					end
				end
				if #joueur[ij].sequence~=sequenceNB then
					fini=false
				end
			end
		end		
	end
end
function verifSecquence(sequence,premier,mode)
	for is=1,#sequence do
		affichage[premier+is].pp.setSlot(1,sequence[is])
		os.sleep(0.5)
		for ij=1,#joueur do
			if joueur[ij].actif then
				if joueur[ij].sequence[is].id==sequence[is].id and joueur[ij].sequence[is].dmg==sequence[is].dmg then
					fenetreColorisation(ij,premier+is,colors.green)
					if not(joueur[ij].perdu) then
						joueur[ij].score=joueur[ij].score+1
					end
				else
					fenetreColorisation(ij,premier+is,colors.red)
					if mode=='score' then
						print(ij..' perdu')
						--joueur[ij].actif=false
						joueur[ij].perdu=true						
					else --versus
						
					end
				end
			end
		end
		os.sleep(1)
	end
	if mode=='score' then
		for ij=1,#joueur do
			if joueur[ij].perdu then
				joueur[ij].actif=false
				joueur[ij].perdu=false
				afficherGrosseInfo(ij,joueur[ij].score)
			end
		end
	end
end
function afficherGrosseInfo(ij,msg)
	for ife=1, #joueur[ij].fenetres do
		fenetreColorisation(ij,ife,joueur[ij].couleur)
	end
	joueur[ij].moniteurs[1].pp.setTextScale(5)
	joueur[ij].fenetreResultat.setVisible(true)
	joueur[ij].fenetreResultat.clear()
	joueur[ij].fenetreResultat.setCursorPos(1,1)
	joueur[ij].fenetreResultat.write(msg)
end

--
local idCoffre=2
local sequenceNB=4
local sequenceJuste={}
local premierSelect=1
local tempsMemo=0.8
local mode='score' -- score versus
local difficulte=1 -- 1 2 3
local partie=true
local ok=true

cleanSelecteurJoueurs()


while true do
	affichageClean()
	moniteurModjeu.pp.setTextScale(1)
	fenetreExplication.setVisible(false)
	fenetreDifficulte.setVisible(false)
	fenetreModjeu.setVisible(true)
	ok=false
	while not(ok) do
		print("Attente mode")
		event, side, xPos, yPos = os.pullEvent("monitor_touch")
		if moniteurModjeu.id==side then
			if yPos==2 then
				ok=true
				mode='score'
			elseif yPos==4 then
				ok=true
				mode='versus'
			end
		end
	end
	print(mode)
	fenetreModjeu.setVisible(false)
	fenetreDifficulte.setVisible(true)
	ok=false
	while not(ok) do
		print("Attente difculter")
		event, side, xPos, yPos = os.pullEvent("monitor_touch")
		if moniteurModjeu.id==side then
			if yPos==1 then
				ok=true
				idCoffre=1
				difficulte=1
				sequenceNB=6
				tempsMemo=0.8
			elseif yPos==3 then
				ok=true
				idCoffre=2
				difficulte=2
				sequenceNB=4
				tempsMemo=1.5
			elseif yPos==5 then
				ok=true
				idCoffre=3
				difficulte=3
				sequenceNB=5
				tempsMemo=1.5
			end
		end
	end
	print("Dificulter "..difficulte)
	moniteurModjeu.pp.setTextScale(0.5)
	fenetreDifficulte.setVisible(false)
	fenetreExplication.setVisible(true)
	for ij=1,#joueur do
		joueur[ij].selecteurs[1].pp.setSlot(1,{id="minecraft:wool",dmg=8})
		joueur[ij].score=0
		joueur[ij].actif=false
		joueur[ij].pret=false
		joueur[ij].perdu=false
		joueur[ij].cache=false
		joueur[ij].numerique={}
		joueur[ij].numeriqueOk={}
		joueur[ij].moniteurs[1].pp.setTextScale(1)
		joueur[ij].fenetreResultat.setVisible(false)
		for ife=1, #joueur[ij].fenetres do
			fenetreColorisation(ij,ife,colors.black)
		end
	end
	cacheEcran()
	fini=false
	while not(fini) do
		event, slot, side = os.pullEvent('slot_click')
		for ij=1,#joueur do
			if joueur[ij].selecteurs[1].id==side then	
				print('-- joueur '..ij)			
				if not(joueur[ij].actif) then				
					joueur[ij].actif=true
					
					for ij2=1,#joueur do
						if joueur[ij2].actif then
							for ife=1, #joueur[ij2].fenetres do
								if ife%2==0 then
									fenetreColorisation(ij2,ife,joueur[ij2].couleur)
								else
									fenetreColorisation(ij2,ife,colors.black)
								end
							end
							joueur[ij2].pret=false
							joueur[ij2].selecteurs[1].pp.setSlot(1,{id="minecraft:wool",dmg=13})
							joueur[ij2].selecteurs[2].pp.setSlot(1,{id="minecraft:wool",dmg=14})
						end
					end
				else
					for ife=1, #joueur[ij].fenetres do
						fenetreColorisation(ij,ife,joueur[ij].couleur)
					end
					joueur[ij].pret=true
					joueur[ij].selecteurs[1].pp.setSlot(1,{id="minecraft:wool",dmg=5})
					joueur[ij].selecteurs[2].pp.setSlot(1,{id="minecraft:wool",dmg=14})
				end
			elseif joueur[ij].selecteurs[2].id==side then
				for ife=1, #joueur[ij].fenetres do
					fenetreColorisation(ij,ife,colors.black)
				end
				print('-- joueur '..ij)	
				joueur[ij].actif=false
				joueur[ij].pret=false
				joueur[ij].selecteurs[1].pp.setSlot(1,{id="minecraft:wool",dmg=8})
				joueur[ij].selecteurs[2].pp.setSlot(1)
			end			
		end
		fini=true
		nbJoueur=0
		for ij=1,#joueur do				
			if joueur[ij].actif then	
				nbJoueur=nbJoueur+1
				if not(joueur[ij].pret) then
					print('joueur '..ij..' non pret')
					fini=false
				end
			end
		end
		if nbJoueur==0 then
			print('Pas de joueur')
			fini=false
		end
	end
	cleanSelecteurJoueurs()
	for ij=1,#joueur do
		joueur[ij].cache=true
	end
	cacheEcran()
	moniteurModjeu.pp.setTextScale(1)
	fenetreExplication.setVisible(false)
	fenetreEncours.setVisible(true)
	partie=true
	afficherSelecteurJoueur(idCoffre)
	while partie do
		for ij=1,#joueur do
			if joueur[ij].actif then
				for is=1,#joueur[ij].numeriqueOk do
					for isl, item in pairs(joueur[ij].numeriqueOk[is]) do
						if not(joueur[ij].numeriqueOk[is][isl]) then
							joueur[ij].numeriqueOk[is][isl]=true
							joueur[ij].selecteurs[is].pp.setSlot(isl,joueur[ij].numerique[is][isl])
						end
					end
				end
				
			end
		end
		sequenceJuste,premierSelect,multiItem=afficherSequence(idCoffre,sequenceNB)
		os.sleep(tempsMemo*sequenceNB)
		affichageClean()
		ecouteJoueur(sequenceNB,premierSelect,multiItem)
		verifSecquence(sequenceJuste,premierSelect,mode)

		if mode=='score' then
			partie=false
			for ij=1,#joueur do
				if joueur[ij].actif then
					partie=true
				end
			end		
		else -- versus
			local scoreMax=0
			local nbJoueur=0
			for ij=1,#joueur do
				if joueur[ij].actif then
					print("Joueur "..ij.." "..joueur[ij].score)
					scoreMax=math.max(scoreMax,joueur[ij].score)
				end
			end
			print("Score "..scoreMax)
			for ij=1,#joueur do
				if joueur[ij].actif then
					if joueur[ij].score<scoreMax then
						
						joueur[ij].actif=false
						afficherGrosseInfo(ij,"PERDU")
					else
						nbJoueur=nbJoueur+1
					end
				end
			end
			if nbJoueur==1 then
				for ij=1,#joueur do
					if joueur[ij].actif then
						afficherGrosseInfo(ij,"GAGNER")
					end
				end
				partie=false
			end
		end
		if difficulte==1 then
			sequenceNB=sequenceNB+2
		elseif difficulte==2 then
			sequenceNB=sequenceNB+1
		else
			sequenceNB=sequenceNB+1
		end
		if sequenceNB>#affichage then
			sequenceNB=#affichage
			if tempsMemo>=0.2 then
				tempsMemo=tempsMemo-0.05
			end
		end
	end
	cleanSelecteurJoueurs()
end