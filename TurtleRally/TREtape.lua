print("LOAD Etape v0.03")
function tirage()
	etapesTirage={}
	for etapesI=1, #etapes do
		table.insert(etapesTirage,etapesI)
	end
	for i=1, #etapes do
		index=math.random(#etapesTirage)
		etapes[i].numero=etapesTirage[index]
		table.remove(etapesTirage,index)
		
		etapes[i].ecran.pp.clear()
		etapes[i].ecran.pp.setTextScale(5)
		etapes[i].ecran.pp.setCursorPos(1,1)
		etapes[i].ecran.pp.write(etapes[i].numero)
	end
end
etapes={}
function add(x,y,id)
	table.insert(etapes,{x=x,y=y,numero=0,ecran=ahb.addPeripheral(id)})
end
function passage(idJoueur,x,y)
	for iEt=1,#etapes do
		if etapes[iEt].x==x and etapes[iEt].y==y then
			joueur.etape(idJoueur,etapes[iEt].numero)
		end
	end
end
function coord(numero)
	for iEt=1,#etapes do
		if etapes[iEt].numero==numero then
			return etapes[iEt].x, etapes[iEt].y
		end
	end
end