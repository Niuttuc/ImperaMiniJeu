print("LOAD Depart v0.04")
departs={}
function add(x,y,idPeri,idTurtle)
	table.insert(departs,{x=x,y=y,numero=0,ecran=ahb.addPeripheral(idPeri),idTurtle=idTurtle})
end
function total()
	return #departs
end
function def(idDepart,idJoueur,couleur,actif)
	departs[idDepart].idJoueur=idJoueur
	if actif then
		departs[idDepart].ecran.pp.setBackgroundColour(couleur)
	else
		departs[idDepart].ecran.pp.setBackgroundColour(colors.black)
	end
	departs[idDepart].ecran.pp.clear()
	return departs[idDepart].x, departs[idDepart].y
end
function joueur(idJoueur)
	for idDepart=1,#departs do 
		if departs[idDepart].idJoueur==idJoueur then
			return departs[idDepart].x, departs[idDepart].y
		end
	end
end