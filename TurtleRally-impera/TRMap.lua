print("LOAD Map v1.04")
local tapis={}
local plaques={}
local maps={}
for x=0, config.get("tailleX")+1 do
	maps[x]={}
	for y=0, config.get("tailleY")+1 do
		if x==0 or x==config.get("tailleX")+1 or y==0 or y==config.get("tailleY")+1 then
			maps[x][y]="trou"
		else
			maps[x][y]="libre"
		end
		
	end
end



-- fonction execute avant deplacement pour verifier deplacement et possible
-- renvoi bool pour deplacement autorise ou non
-- verifier apres si il n y pas un autre joueur
-- renvoi degat subit
local tuilesAvent={
	libre=function(x,y) return true, 0 end,
	depart=function(x,y) return true, 0 end,
	mur=function(x,y) return false,0 end,
	mur2=function(x,y)
		if mur.getEtat(x,y) then return false, 0
		else return true,0 end
	end,
	bout=function(x,y) return true,0 end,
	map=function(x,y) return true,0 end,
	pique=function(x,y)
		return false,1
	end,
	tapis=function(x,y) return true,0 end,
	pt=function(x,y) return true,0 end,
	bonus=function(x,y) return true,0 end,
	trou=function(x,y) return true,0 end,
	laser=function(x,y) return false,0 end,
	etape=function(x,y) return true,0 end
}
function preAction(case,x,y)
	return tuilesAvent[case](x,y)
end
-- Fonction execute apres deplacement ou rotation du joueur
-- Les tapis, engrenage et validation d'etape ne se font pas ici
tuilesOver={
	libre=function(idJoueur,x,y) return end,
	mur2=function(idJoueur,x,y) return end,
	depart=function(idJoueur,x,y) return end,
	bout=function(idJoueur,x,y)
		mur.test(x,y)
		return
	end,
	tapis=function(idJoueur,x,y) return end,	
	pt=function(idJoueur,x,y) return end,
	bonus=function(idJoueur,x,y)
		bonus.action(idJoueur,x,y)		
		return
	end,
	trou=function(idJoueur,x,y)
		joueur.mort(idJoueur)
		return
	end,
	laser=function(idJoueur,x,y) return	end,
	etape=function(idJoueur,x,y) return end
}
tuilesOut={
	libre=function(x,y) return end,
	depart=function(x,y) return end,
	mur2=function(x,y) return end,
	bout=function(x,y)return end,
	tapis=function(x,y)	return end,
	bonus=function(x,y)
		bonus.tiragePos(x,y)
		return
	end,
	tapis=function(x,y) return end,
	pt=function(x,y) return end,
	trou=function(x,y)	return end,
	laser=function(x,y) return end,
	etape=function(x,y) return end
}
function posteAction1(x,y,idJoueur)	
	local case=maps[x][y]
	tuilesOut[case](x,y)
end
function posteAction2(case,x,y,idJoueur)
	tuilesOver[case](idJoueur,x,y)	
end

function add(x,y,ttype,info,info2,info3)
	maps[x][y]=ttype
	if ttype=="mur2" then
		mur.add(info,x,y,info2)
	elseif ttype=="bout" then
		mur.addBouton(info,x,y)
	elseif ttype=="laser" then
		laser.add(x,y,info)
	elseif ttype=="tapis" then
		info.x=x
		info.y=y
		table.insert(tapis,info)
	elseif ttype=="pt" then
		local info28={}
		info28.x=x
		info28.y=y
		info28.rot=info
		info28.red=info2
		table.insert(plaques,info28)
	elseif ttype=="depart" then
		depart.add(x,y,info,info2,info3)
	elseif ttype=="bonus" then
		bonus.add(x,y,info)
	elseif ttype=="etape" then
		etape.add(x,y,info,info2,info3)
	end
end
function inmap(x,y)
	if type(maps[x])=='nil' then
		return false
	elseif type(maps[x][y])=='nil' then
		return false
	end
	return true
end
function get(x,y)	
	if not(inmap(x,y)) then
		return 'trou'
	end
	return maps[x][y]
end
groupeTapis={}
function addGroupeTapis(groupe,periphs)
	groupeTapis[groupe]={}
	for iPeriphs=1, #periphs do
		table.insert(groupeTapis[groupe],ahb.addPeripheral('hb_interupteur_'..periphs[iPeriphs]))
	end	
end
function actionTapis()
	joueur.itapisReset()
	for iTapis=1, #tapis do
		local idJoueur=joueur.presentGetId(tapis[iTapis].x,tapis[iTapis].y)		
		if not(idJoueur==-1) then
			if joueur.itapis(idJoueur) then
				for iPeriphs=1, #groupeTapis[tapis[iTapis].red] do
					groupeTapis[tapis[iTapis].red][iPeriphs].pp.set(15)
				end
				print("TAPIS")
				joueur.deplacement(idJoueur,tapis[iTapis].x+tapis[iTapis].mx,tapis[iTapis].y+tapis[iTapis].my,false)
				joueur.itapisOff(idJoueur)	
				for iPeriphs=1, #groupeTapis[tapis[iTapis].red] do
					groupeTapis[tapis[iTapis].red][iPeriphs].pp.set(0)
				end
			end
		end
	end
	
	for iTapis=1, #tapis do
		local idJoueur=joueur.presentGetId(tapis[iTapis].x,tapis[iTapis].y)		
		if not(idJoueur==-1) then
			print("ROT "..tapis[iTapis].rot)
			if not(tapis[iTapis].rot=="non") then
				for iPeriphs=1, #groupeTapis[tapis[iTapis].red] do
					groupeTapis[tapis[iTapis].red][iPeriphs].pp.set(15)
				end
				joueur.tourne(idJoueur,tapis[iTapis].rot)
				for iPeriphs=1, #groupeTapis[tapis[iTapis].red] do
					groupeTapis[tapis[iTapis].red][iPeriphs].pp.set(0)
				end
			end
		end
	end
	
	
	for iPlaque=1, #plaques do
		local idJoueur=joueur.presentGetId(plaques[iPlaque].x,plaques[iPlaque].y)
		if not(idJoueur==-1) then
			for iPeriphs=1, #groupeTapis[plaques[iPlaque].red] do
				groupeTapis[plaques[iPlaque].red][iPeriphs].pp.set(15)
			end
			joueur.tourne(idJoueur,plaques[iPlaque].rot)
			for iPeriphs=1, #groupeTapis[plaques[iPlaque].red] do
				groupeTapis[plaques[iPlaque].red][iPeriphs].pp.set(0)
			end
		end
	end
	
	
	etape.verif()	
end