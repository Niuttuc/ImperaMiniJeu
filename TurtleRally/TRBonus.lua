print("LOAD bonus v0.02")
bonus={}
items={
	damageothers={id='minecraft:tnt'},
	damageself={id='minecraft:skull'},
	heal={id='witchery:ingredient',dmg=165}, -- TConstruct:heartCanister
	reroll={id='chisel:futura',dmg=2}
}
liste={"heal","damageothers","damageself"}
fc={
	heal=function() end,
	damageothers=function() end,
	damageself=function() end,
	reroll=function() end
}
function add(x,y,nom)
	table.insert(bonus,{
		x=x,
		y=y,
		selector=ahb.addPeripheral(nom),
		bonus="",
		actif=true
	})
end
function change(idBonus,nom)
	bonus[idBonus].bonus=nom
	bonus[idBonus].actif=true
	bonus[idBonus].selector.pp.setSlot(1,items[nom])		
end
function tirage(idBonus)
	if not(joueur.present(bonus[idBonus].x,bonus[idBonus].y)) then
		change(idBonus,liste[math.random(#liste)])
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