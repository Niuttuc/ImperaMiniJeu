print("LOAD bonus v0.03")
bonus={}
items={
	damageothers={id='minecraft:tnt'},
	damageself={id='minecraft:skull'},
	heal={id='witchery:ingredient',dmg=165}, -- TConstruct:heartCanister
	reroll={id='chisel:futura',dmg=2}
}
dessins={
	damageothers=img=paintutils.loadImage("dessin/damageothers"),
	damageself=paintutils.loadImage("dessin/damageself"),
	heal=paintutils.loadImage("dessin/heal"), -- TConstruct:heartCanister
	reroll=paintutils.loadImage("dessin/reroll")
}

liste={"heal","damageothers","damageself"}
fc={
	heal=function(idJoueur) 
		joueur.heal(idJoueur)
	end,
	damageothers=function(idJoueur) 
		joueur.degatAll(idJoueur)
	end,
	damageself=function(idJoueur) 
		joueur.degat(idJoueur)
		joueur.degat(idJoueur)
	end,
	reroll=function(idJoueur)
		tirageAll()
	end
}
function add(x,y,nom)
	local data={
		x=x,
		y=y,
		bonus="",
		actif=true
	}
	if config.get(openperipheral) then
		data.selector=ahb.addPeripheral(nom)
	else
		data.selector=false
		data.monitor=ahb.addPeripheral(nom)
	end
	table.insert(bonus,data)
end
function change(idBonus,nom)
	print("Bonus change "..idBonus.." "..nom)
	bonus[idBonus].bonus=nom
	bonus[idBonus].actif=true
	if bonus[idBonus].selector then
		bonus[idBonus].selector.pp.setSlot(1,items[nom])
	else
		term.redirect(bonus[idBonus].monitor.pp)
		paintutils.drawImage(dessins[nom],1,1)
		term.redirect(term.native())
	end
end
function tiragePos(x,y)
	for idBonus=1, #bonus do
		if bonus[idBonus].x==x and bonus[idBonus].y==y then
			tirage(idBonus)
		end
	end
end
function tirage(idBonus)
	if not(joueur.present(bonus[idBonus].x,bonus[idBonus].y)) then
		
		change(idBonus,liste[math.random(#liste)])
	end
end
function action(idJoueur,x,y)
	for idBonus=1, #bonus do
		if bonus[idBonus].x==x and bonus[idBonus].y==y then
			fc[bonus[idBonus].bonus](idJoueur)
		end
	end
end
function tirageAll()
	local copieBonus={}
	for idBonus=1, #bonus do
		if not(joueur.present(bonus[idBonus].x,bonus[idBonus].y)) then
			table.insert(copieBonus,idBonus)	
		end
	end
	print(#copieBonus)
	
	-- Tirage du reroll
	local index=math.random(#copieBonus)
	change(copieBonus[index],"reroll")
	table.remove(copieBonus,index)	
	
	-- Tire tous les autres avec tirageBonus()
	for icb=1, #copieBonus do
		tirage(copieBonus[icb])
	end	
end