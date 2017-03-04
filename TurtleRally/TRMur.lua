print("LOAD mur v0.06")
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
local redstoneSide=config.get("redstone")

function add(couleur,x,y)
	table.insert(mur[couleur].position,{x=x,y=y})
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
	for cMur, data in pairs(mur) do
		if not(cMur==couleurBouton) then
			local joueurDessus=false
			for iMur,pos in pairs(data.position) do
				if joueur.present(pos.x,pos.y) then
					joueurDessus=true
				end
			end
		end
	end
	if joueurDessus==false then
		for cMur, data in pairs(mur) do
			if cMur==couleurBouton then
				mur[cMur].etat=true
			else
				mur[cMur].etat=false
			end
		end
		redstone.getBundledInput(redstoneSide,mur[couleurBouton].couleur)
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
	mur["rouge"].etat=false
	mur["bleu"].etat=false
	redstone.getBundledInput(redstoneSide,0)
end