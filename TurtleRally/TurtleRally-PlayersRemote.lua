modem=peripheral.find('modem')
colorString=string.lower(string.sub(os.getComputerLabel(),7,-1))
color=colors[colorString]
modem.open(color+1)
xmax,ymax=term.getSize()
os.loadAPI('ahb')
os.loadAPI('windows')
os.loadAPI('choices')
os.loadAPI('sync')
os.loadAPI('clicAPI')
totalWeight=0
for k,v in pairs(choices) do
	totalWeight=totalWeight+v.weight
end



function affWin(win)
	currentWin.setVisible(false)
	currentWin=win
	currentWin.setVisible(true)
end

function quit()
	affWin(windows.leaveGame)
	sleep(2)
	os.shutdown()
end
thingsToDo={os.pullEvent,'modem_message'}
currentWin=windows.waitingScreen
while true do
	idArret,ret1,ret2,ret3,ret4,ret5=sync.waitForAny(sync.listArgs(thingsToDo))
	if idArret==1 then
		ev,side,freq,repFreq,message=ret1,ret2,ret3,ret4,ret5
		if message.action=="WAIT" then
			affWin(windows.waitingScreen)
			thingsToDo={os.pullEvent,'modem_message'}
		else message.action=="LOBBY" then
			affWin(windows.beforeGame)
			thingsToDo={os.pullEvent,'modem_message',clicAPI.waitClic,{xmax-6,1,xmax,3,quit}}
		end
	end
end