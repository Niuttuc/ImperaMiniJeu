print("LOAD Etape v0.06")
local etapesTirage={}
function tirage2(numero)
	index=math.random(#etapesTirage)
	iEtape=etapesTirage[index]
	etapes[iEtape].numero=numero
	if numero>config.get("etape") then
		etapes[iEtape].numero=""
	end
	table.remove(etapesTirage,index)
	
	etapes[iEtape].ecran.pp.clear()
	etapes[iEtape].ecran.pp.setTextScale(5)
	etapes[iEtape].ecran.pp.setCursorPos(1,1)
	etapes[iEtape].ecran.pp.write(numero)
end
function tirage()
	etapesTirage={}
	for etapesI=1, #etapes do
		etapes[etapesI].numero=""
		if etapes[etapesI].first then
			table.insert(etapesTirage,etapesI)
		end
	end
	tirage2(1)
	
	for etapesI=1, #etapes do
		if etapes[etapesI].numero=="" then
			table.insert(etapesTirage,etapesI)
		end
	end
	for i=2, #etapes do
		tirage2(i)
	end
end
etapes={}
function add(x,y,id,orientation,first)
	table.insert(etapes,{x=x,y=y,orientation=orientation,numero=0,ecran=ahb.addPeripheral(id),first=first})
end
function coord(numero)
	for iEt=1,#etapes do
		if etapes[iEt].numero==numero then
			return etapes[iEt].x, etapes[iEt].y, etapes[iEt].orientation
		end
	end
end
function verif()
	for iEt=1,#etapes do
		local idJoueur=joueur.presentGetId(etapes[iEt].x,etapes[iEt].y)
		if not(idJoueur==-1) then
			print("ETAPE joueur trouve")
			if not(etapes[iEt].numero=="") then				
				joueur.passageEtape(idJoueur,etapes[iEt].numero)
			end
		end
	end
end