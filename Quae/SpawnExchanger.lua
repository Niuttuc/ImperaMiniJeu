chestRod=peripheral.wrap("right")
chestRecord=peripheral.wrap("left")
monitor=peripheral.wrap("top")

function scan(chest,item)
	chest.condenseItems()
	allStacks=chest.getAllStacks()
	qty=0
	for i=1,#allStacks do
		stack=allStacks[i].all()
		if stack.display_name==item then
			qty=qty+stack.qty
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
		while qtyIron>=3 do
			chestRod.pushItem("south",1,math.min(math.floor(qtyIron/3)*3,64),1)
			qtyIron=scan(chestRod,"Iron Ingot")
		end
		while qtyBlankRecords>=1 do
			chestRecord.pushItem("south",1,1,1)
			qtyBlankRecords=scan(chestRecord,"Blank Record")
		end
		for i=1,qtyBlankRecordsInit do
			chestRecord.pullItem("down",2,1,5+i)
		end
		i=1	
		while math.floor(qtyIronInit/3)>=64 do
			chestRod.pullItem("down",2,64,6+i)
			qtyIronInit=qtyIronInit-64*3
			i=i+1
		end
		chestRod.pullItem("down",2,math.floor(qtyIronInit/3),6+i)
	end
end

wait()