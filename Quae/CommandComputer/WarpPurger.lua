ItemChest=peripheral.wrap("right")

monitor=peripheral.wrap("top")

function scan(chest,item)
	chest.condenseItems()
	allStacks=chest.getAllStacks()
	qty=0
	for i=1,#allStacks do
		stack=allStacks[i].all()
		if stack.id==item then
			qty=qty+stack.qty
		end
	end
	return qty
end

function wait()
	monitor.setTextScale(2)
	xmax,ymax=monitor.getSize()
	monitor.setCursorPos(math.floor(xmax/2)-10, math.floor(ymax/2)-1)
	monitor.write("Purgez vous du Warp!")
	monitor.setCursorPos(math.floor(xmax/2)-13, math.floor(ymax/2))
	monitor.write("1 Primal crusher, 64 savons")
	monitor.setCursorPos(math.floor(xmax/2)-9, math.floor(ymax/2)+1)
	monitor.write("Appuyez sur l'ecran")
	monitor.setCursorPos(math.floor(xmax/2)-10, math.floor(ymax/2)+2)
	monitor.write("Pour lancer l'echange")
	while true do
		ev,side=os.pullEventRaw("monitor_touch")
		qtyCrusher=scan(ItemChest,"Thaumcraft:ItemPrimalCrusher")
		qtySoap=scan(ItemChest,"Thaumcraft:ItemSanitySoap")
		if qtyCrusher==1 and qtySoap==64 then
			ans1=ItemChest.pushItem("down",1,1,1)
			ans2=ItemChest.pushItem("down",2,64,1)
			if ans1==1 and ans2==64 then
				command.thaumcraft("warp @p set 0")
				command.thaumcraft("warp @p set 0 PERM")
				command.thaumcraft("warp @p set 0 TEMP")
				command.say("@p a ete purifie!")
			end
		end
	end
end

wait()