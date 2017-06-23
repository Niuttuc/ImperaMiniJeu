print("LOAD mur v1.00")
local mur={
	rouge={
		etat=true,
		couleur=colors.red,
		position={},
		positionBt={}
	},
	bleu={
		etat=true,
		couleur=colors.blue,
		position={},
		positionBt={}
	}
}

function add(couleur,x,y,redstonePP)
	table.insert(mur[couleur].position,{x=x,y=y,redstone=ahb.addPeripheral(redstonePP)})
end
function addBouton(couleur,x,y)
	table.insert(mur[couleur].positionBt,{x=x,y=y})
end
-- Verification de la presence d'un joueur sur le mur Up
-- couleurUp Couleur du mur qui monte
-- couleurDown Couleur du mur qui descend
function test(x,y)
	couleurBouton=""
	for cMur, data in pairs(mur) do
		for i, pos in pairs(data.positionBt) do
			if pos.x==x and pos.y == y then
				couleurBouton=cMur
			end
		end
	end
	if couleurBouton=="" then
		error("Pas de mur en "..x.." "..y)
	end
	print("Couleur "..couleurBouton)
	local joueurDessus=false
	for cMur, data in pairs(mur) do
		if not(cMur==couleurBouton) then			
			for iMur,pos in pairs(data.position) do
				if joueur.present(pos.x,pos.y) then
					print("Joueur present sur un mur "..cMur)
					joueurDessus=true
				end
			end
		end
	end
	if joueurDessus==false then
		print("Changement de mur")
		couleurs=0
		for cMur, data in pairs(mur) do
			if cMur==couleurBouton then
				mur[cMur].etat=false
				for iMur,pos in pairs(data.position) do
					pos.redstone.pp.set(0)
				end
			else
				mur[cMur].etat=true
				for iMur,pos in pairs(data.position) do
					pos.redstone.pp.set(15)
				end
			end
		end
	end
end
function getEtat(x,y)
	for cMur, data in pairs(mur) do
		for i, pos in pairs(data.position) do
			if pos.x==x and pos.y == y then
				return data.etat
			end
		end
	end
	error("Pas de mur en "..x.." "..y)
end
function reset()
	for cMur, data in pairs(mur) do
		mur[cMur].etat=false
		for iMur,pos in pairs(data.position) do
			pos.redstone.pp.set(0)
		end
	end
	
end