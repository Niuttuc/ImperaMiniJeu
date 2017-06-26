chestRod=peripheral.wrap("right")
chestRecord=peripheral.wrap("left")
monitor=peripheral.wrap("top")

function scan(chest,item)
	chest.condenseItem()
	allStacks=chest.getAllStacks
	qty={tot=0}
	for i=1,#allStacks do
		stack=allStacks[i].all()
		if stack.item_name==item then
			qty={[i]=stack.qty}
			qty.tot=qty.tot+stack.qty
		end
	end
	return qty
end

function wait()
	monitor.setCursorPos(1, 1)
	monitor.write("Appuyez sur l'ecran")
	monitor.setCursorPos(1, 2)
	monitor.write("Pour lancer l'echange")
	while true do
		ev,side=os.pullEventRaw("monitor_touch")
		qtyIronInit=scan(chestRod,"Iron Ingot")
		qtyIron=qtyIronInit
		qtyBlankRecordsInit=scan(chestRecord,"Blank Record")
		qtyBlankRecords=qtyBlankRecordsInit
		while qtyIron.tot>=3 do
			chestRod.pushItems("south",1,math.min(math.floor(qtyIron.tot/3),64),1)
			qtyIron=scan(chestRod,"Iron Ingot")
		end
		while qtyBlankRecords.tot>=1 do
			chestRecord.pushItems("south",1,1,1)
			qtyBlankRecords=scan(chestRecord,"Blank Record")
		end
		for i=1,qtyBlankRecordsInit.tot do
			chestRecord.pullItem("down",1,1,5+i)
		end
		i=1
		while math.floor(qtyIronInit.tot/3)>=64 do
			chestRod.pullItem("down",1,64,6+i)
			i=i+1
		end
		chestRod.pullItem("down",1,64,6+i)
	end
end

wait()