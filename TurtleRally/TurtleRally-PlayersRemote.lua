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
	modem.transmit(84,color+1,'LEAVE')

	modem.transmit(84,color+1,'JOIN')
end
thingsToDoFc={os.pullEvent}
thingsToDoArg={'modem_message'}
currentWin=windows.waitingScreen
premierLancement=true
modem.transmit(84,color+1,'JEFAITQUOI')

while true do
	
	idArret,ret1,ret2,ret3,ret4,ret5=sync.waitForAny(thingsToDoFc,thingsToDoArg)
	
	print("idArret "..idArret)
	if idArret==1 then
		ev,side,freq,repFreq,message=ret1,ret2,ret3,ret4,ret5
		print(message.action)
		if message.action=="JOIN" then
			if premierLancement then
				modem.transmit(84,color+1,'JOIN')
			else
				affWin(windows.leaveGame)				
			end
			thingsToDoFc={os.pullEvent,clicAPI.waitClic}
			thingsToDoArg={'modem_message',{1,1,xmax,ymax,join}}
		elseif message.action=="WAIT" then
			affWin(windows.waitingScreen)
			thingsToDoFc={os.pullEvent}
			thingsToDoArg={'modem_message'}
		elseif message.action=="LOBBY" then
			affWin(windows.beforeGame)
			thingsToDoFc={os.pullEvent,clicAPI.waitClic}
			thingsToDoArg={'modem_message',{xmax-6,1,xmax,3,quit}}
		end
	end
	premierLancement=false
end