print("LOAD Etape v0.05")
function tirage()
	etapesTirage={}
	for etapesI=1, #etapes do
		table.insert(etapesTirage,etapesI)
	end
	for i=1, #etapes do
		index=math.random(#etapesTirage)
		etapes[i].numero=etapesTirage[index]
		if etapes[i].numero>config.get("etape") then
			etapes[i].numero=""			
		end
		table.remove(etapesTirage,index)
		
		etapes[i].ecran.pp.clear()
		etapes[i].ecran.pp.setTextScale(5)
		etapes[i].ecran.pp.setCursorPos(1,1)
		etapes[i].ecran.pp.write(etapes[i].numero)
	end
end
etapes={}
function add(x,y,id,orientation)
	table.insert(etapes,{x=x,y=y,orientation=orientation,numero=0,ecran=ahb.addPeripheral(id)})
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