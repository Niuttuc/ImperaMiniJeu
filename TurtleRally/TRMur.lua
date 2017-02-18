print("LOAD mur v0.04")
local mur={
	rouge={
		etat=true,
		couleur=colors.red,
		position={}
	},
	bleu={
		etat=true,
		couleur=colors.blue,
		position={}
	}
}
local redstoneSide=config.get(redstone)

function add(couleur,x,y)
	table.insert(mur[couleur].position,{x=x,y=y})
end
-- Verification de la presence d'un joueur sur le mur Up
-- couleurUp Couleur du mur qui monte
-- couleurDown Couleur du mur qui descend
function test(couleurUp,couleurDown) 
	local joueurDessus=false
	for iMur,pos in pairs(mur[couleurUp].position) do
		if joueur.present(pos.x,pos.y) then
			joueurDessus=true
		end
	end
	if joueurDessus==false then
		mur[couleurUp].etat=true
		mur[couleurDown].etat=false
		redstone.getBundledInput(redstoneSide,mur[couleurUp].couleur)
	end	
end
function getEtat(couleur)
	return mur[couleur].etat
end
function reset()
	mur["rouge"].etat=false
	mur["bleu"].etat=false
	redstone.getBundledInput(redstoneSide,0)
end