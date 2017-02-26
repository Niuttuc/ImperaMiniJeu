print("LOAD Map v0.07")

-- fonction execute avant deplacement pour verifier deplacement et possible
-- renvoi bool pour deplacement autorise ou non
-- verifier apres si il n y pas un autre joueur
-- renvoi degat subit
local tuilesAvent={
	libre=function(x,y) return true, 0 end,
	mur=function(x,y) return false,0 end,
	mur2=function(x,y)
		if mur.getEtat(x,y) then return false, 0
		else return true,0 end
	end,
	bout=function(x,y) return true,0 end,
	pique=function(x,y)
		return false,1
	end,
	tapis=function(x,y) return true,0 end,
	bonus=function(x,y) return true,0 end,
	trou=function(x,y) return true,0 end,
	laser=function(x,y) return true,0 end,
	etape=function(x,y) return true,0 end
}
function preAction(case,x,y)
	return tuilesAvent[case](x,y)
end
-- Fonction execute apres deplacement ou rotation du joueur
-- Les tapis, engrenage et validation d'etape ne se font pas ici
tuilesOver={
	libre=function(idJoueur,x,y,tapis) return end,
	mur2=function(idJoueur,x,y,tapis) return end,
	bout=function(idJoueur,x,y,tapis)
		mur.test("bleu","rouge")
		mur.test("rouge","bleu")
		return
	end,
	tapiXP=function(idJoueur,x,y,tapis) return end,
	bonus=function(idJoueur,x,y,tapis)
		bonus.action(idJoueur,x,y)		
		return
	end,
	trou=function(idJoueur,x,y,tapis)
		joueur.mort()
		return
	end,
	laser=function(idJoueur,x,y,tapis)
		joueur.degat(idJoueur)
		return
	end,
	etape=function(idJoueur,x,y,tapis) return end
}
tuilesFinTour={
	etape=function(idJoueur,x,y,tapis)
		return
	end
}
tuilesOut={
	libre=function(x,y) return end,
	mur2=function(x,y) return end,
	bout=function(x,y)return end,
	tapis=function(x,y)	return end,
	bonus=function(x,y)
		bonus.tiragePos(x,y)
		return
	end,
	trou=function(x,y)return	end,
	laser=function(x,y) return end,
	etape=function(x,y) return end
}
function posteAction(case,x,y,idJoueur,tapis,dernier)
	tuilesOver[map](idJoueur,x,y,tapis)
	tuilesOut[map](x,y)
end
local maps={}
for x=1, config.get("tailleX") do
	maps[x]={}
	for y=1, config.get("tailleY") do
		maps[x][y]="libre"
	end
end

local tapis={}
local plaques={}
function add(x,y,ttype,info,info2)
	maps[x][y]=ttype
	if ttype=="mur2" then
		mur.add(info,x,y)
	elseif ttype=="tapis" then
		info.x=x
		info.y=y
		table.insert(tapis,info)
	elseif ttype=="plaque" then
		infos2={}
		info2.x=x
		info2.y=y
		info2.rot=info
		table.insert(plaques,info2)
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
function actionTapis()
	for iTapis=1, #tapis do
		local idJoueur=joueur.presentGetId(tapis[iTapis].x,tapis[iTapis].y)
		if not(idJoueur==-1) then			
			joueur.deplacement(idJoueur,tapis[iTapis].x+tapis[iTapis].mx,tapis[iTapis].y+tapis[iTapis].my,false)
			if not(tapis[iTapis].rot=="NON") then
				tourne(idJoueur,tapis[iTapis].rot)
			end
		end
	end
	for iPlaque=1, #plaques do
		local idJoueur=joueur.presentGetId(plaques[iPlaque].x,plaques[iPlaque].y)
		if not(idJoueur==-1) then			
			tourne(idJoueur,plaques[iPlaque].rot)
		end
	end
	etape.verif()
	
end