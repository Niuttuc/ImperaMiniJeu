print("LOAD Map v0.06")

-- fonction execute avant deplacement pour verifier deplacement et possible
-- renvoi bool pour deplacement autorise ou non
-- verifier apres si il n y pas un autre joueur
-- renvoi degat subit
local tuilesAvent={
	libre=function(x,y)
		return true, 0
	end,
	mur=function(x,y)
		return false,0
	end,
	mur2=function(x,y)
		if mur.getEtat(x,y) then return false, 0
		else return true,0 end
	end,
	bout=function(x,y)
		return true,0
	end,
	pique=function(x,y)
		return false,1
	end,
	tapiXP=function(x,y)
		return true,0
	end,
	tapiXM=function(x,y)
		return true,0
	end,
	tapiYM=function(x,y)
		return true,0
	end,
	tapiYP=function(x,y)
		return true,0
	end,
	bonus=function(x,y)
		return true,0
	end,
	trou=function(x,y)
		return true,0
	end,
	laser=function(x,y)
		return true,0
	end,
	etape=function(x,y)
		return true,0
	end
}
function preAction(case,x,y)
	return tuilesAvent[case](x,y)
end
-- Fonction execute apres deplacement ou rotation du joueur
tuilesFixe={
	libre=function(idJoueur,x,y) return end,
	mur2=function(idJoueur,x,y) return end,
	bout=function(idJoueur,x,y) return end,
	tapiXP=function(idJoueur,x,y)		
		joueur.deplacement(idJoueur,x+1,y,-1,true)
		return
	end,
	tapiXM=function(idJoueur,x,y)
		joueur.deplacement(idJoueur,x-1,y,-1,true)
		return
	end,
	tapiYP=function(idJoueur,x,y)
		joueur.deplacement(idJoueur,x,y+1,-1,true)
		return
	end,
	tapiYM=function(idJoueur,x,y)
		joueur.deplacement(idJoueur,x,y-1,-1,true)
		return
	end,
	bonus=function(idJoueur,x,y) return end,
	trou=function(idJoueur,x,y) return end,
	laser=function(idJoueur,x,y)
		joueur.degat(idJoueur)
		return
	end,
	etape=function(idJoueur,x,y) return end
}
tuilesOver={
	libre=function(idJoueur,x,y,tapis) return end,
	mur2=function(idJoueur,x,y,tapis) return end,
	bout=function(idJoueur,x,y,tapis)
		mur.test("bleu","rouge")
		mur.test("rouge","bleu")
		return
	end,
	tapiXP=function(idJoueur,x,y,tapis)
		if not(tapis) then
			joueur.deplacement(idJoueur,x+1,y,-1,true)
		end
		return
	end,
	tapiXM=function(idJoueur,x,y,tapis)
		if not(tapis) then
			joueur.deplacement(idJoueur,x-1,y,-1,true)
		end
		return
	end,
	tapiYP=function(idJoueur,x,y,tapis)
		if not(tapis) then
			joueur.deplacement(idJoueur,x,y+1,-1,true)
		end
		return
	end,
	tapiYM=function(idJoueur,x,y,tapis)
		if not(tapis) then
			joueur.deplacement(idJoueur,x,y-1,-1,true)
		end
		return
	end,
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
	etape=function(idJoueur,x,y,tapis)
		etape.passage(idJoueur,x,y)
		return
	end
}
tuilesOut={
	libre=function(x,y) return end,
	mur2=function(x,y) return end,
	bout=function(x,y)return end,
	tapiXP=function(x,y)	return end,
	tapiXM=function(x,y)	return end,
	tapiYP=function(x,y)	return end,
	tapiYM=function(x,y)	return end,
	bonus=function(x,y)
		bonus.tiragePos(x,y)
		return
	end,
	trou=function(x,y)return	end,
	laser=function(x,y) return end,
	etape=function(x,y) return end
}
function posteAction(case,x,y,idJoueur,tapis)
	tuilesOver[map](idJoueur,x,y,tapis)
	tuilesOut[map](x,y)
end
function posteNoAction(case,x,y,idJoueur)
	tuilesFixe[map](idJoueur,x,y)
end


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