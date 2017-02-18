print("LOAD Depart v0.03")
departs={}
function add(x,y,idPeri,idTurtle)
	table.insert(departs,{x=x,y=y,numero=0,ecran=ahb.addPeripheral(idPeri),idTurtle=idTurtle})
end