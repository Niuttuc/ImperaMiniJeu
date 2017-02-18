print("LOAD Map v0.05")

-- fonction execute avant deplacement pour verifier deplacement et possible
-- renvoi bool pour deplacement autorise ou non
-- verifier apres si il n y pas un autre joueur
-- renvoi degat subit
tuilesAvent={
	libre=function()
		return true, 0
	end,
	mur=function()
		return false,0
	end,
	murR=function()
		if mur.getEtat("rouge") then return false, 0
		else return true,0 end
	end,
	murB=function()
		if mur.getEtat("bleu") then return false, 0
		else return true,0 end
	end,
	boutR=function()
		return true,0
	end,
	boutB=function()
		return true,0
	end,
	pique=function()
		return false,1
	end,
	tapiXP=function()
		return true,0
	end,
	tapiXM=function()
		return true,0
	end,
	tapiYM=function()
		return true,0
	end,
	tapiYP=function()
		return true,0
	end,
	bonus=function()
		return true,0
	end,
	trou=function()
		return true,0
	end,
	laser=function()
		return true,0
	end,
	etape=function()
		return true,0
	end
}
-- Fonction execute apres deplacement ou rotation du joueur
tuilesApres={
	libre=function(joueur) return end,
	murR=function(joueur) return end,
	murB=function(joueur) return end,
	boutR=function(joueur)
		mur.test("bleu","rouge")
		return
	end,
	boutB=function(joueur)
		mur.test("rouge","bleu")
		return
	end,
	tapiXP=function(joueur)
		-- Deplacer le joueur de 1 en X (SAUF SI C'EST UN TAPIS QUI A DEPLACER LE JOUEUR)
		return
	end,
	tapiXM=function(joueur)
		-- Deplacer le joueur de -1 en X SAUF SI C'EST UN TAPIS QUI A DEPLACER LE JOUEUR)
		return
	end,
	tapiYP=function(joueur)
		-- Deplace le joueur de 1 en Y SAUF SI C'EST UN TAPIS QUI A DEPLACER LE JOUEUR)
		return
	end,
	tapiYM=function(joueur)
		-- Deplacer le joueur de -1 en Y SAUF SI C'EST UN TAPIS QUI A DEPLACER LE JOUEUR)
		return
	end,
	bonus=function(joueur)
		-- Execute le bonus
		return
	end,
	trou=function(joueur)
		-- Envoi la turtle dans le troue pret a teleporter, enlever une vie, remet a X coeurs
		return
	end,
	laser=function(joueur)
		-- Enleve un coeur
		return
	end,
	etape=function(joueur)
		-- valide l'etape
		return
	end
}

local maps={}
for x=1, config.get("tailleX") do
	maps[x]={}
	for y=1, config.get("tailleY") do
		maps[x][y]="libre"
	end
end
function add(x,y,ttype,info,info2)
	maps[x][y]=ttype
	if ttype=="mur2" then
		mur.add(info,x,y)
	elseif ttype=="depart" then
		depart.add(x,y,info,info2)
	elseif ttype=="bonus" then
		bonus.add(x,y,info)
	elseif ttype=="etape" then
		etape.add(x,y,info)
	end
end
function get(x,y)
	return maps[x][y]
end