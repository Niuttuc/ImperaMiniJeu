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
local coeur=0
local vie=0
local checkpoint=0
function affWin(win)
	currentWin.setVisible(false)
	currentWin=win
	currentWin.setVisible(true)
end
function quit()
	modem.transmit(84,color+1,'LEAVE')
	thingsToDo={os.pullEvent,'modem_message'}
end
function join()
  	modem.transmit(84,color+1,'JOIN')
	thingsToDo={os.pullEvent,'modem_message'}
end
function actuDonne(data)
	coeur=data.coeur
	vie=data.vie
	checkpoint=data.checkpoint
end
local derTirage={}
function tirage()
	local tirageA
	for k,v in pairs(choices) do
		for i=1, v.weight then
			table.insert(tirageA,k)
		end
	end
	derTirage={}
	for i=1, coeur do
		choiceColumn.setCursorPos(1,i)
		index=math.random(#tirageA)
		table.insert(derTirage,tirageA[index])
		choiceColumn.write(choices[tirageA[index]].nomListe)
		table.remove(tirageA,index)
	end
	affWin(windows.playWindow)
end
thingsToDo={os.pullEvent,'modem_message'}
currentWin=windows.waitingScreen
premierLancement=true
modem.transmit(84,color+1,'JEFAITQUOI')

while true do
	idArret,ret1,ret2,ret3,ret4,ret5=sync.waitForAny(sync.listArgs(thingsToDo))
	if idArret==1 then
		ev,side,freq,repFreq,message=ret1,ret2,ret3,ret4,ret5
		if message.action=="JOIN" then
			if premierLancement then
				modem.transmit(84,color+1,'JOIN')
			else
				affWin(windows.leaveGame)				
			end
			thingsToDo={os.pullEvent,'modem_message',clicAPI.waitClic,{1,1,xmax,ymax,join}}
		elseif message.action=="WAIT" then
			affWin(windows.waitingScreen)
			thingsToDo={os.pullEvent,'modem_message'}
		elseif message.action=="LOBBY" then
			affWin(windows.beforeGame)
			thingsToDo={os.pullEvent,'modem_message',clicAPI.waitClic,{xmax-6,1,xmax,3,quit}}
		elseif message.action=="TOOLATE" then
			affWin(windows.gameInProgress)
			thingsToDo={os.pullEvent,'modem_message'}
		elseif message.action=="CHOIX" then
			thingsToDo={os.pullEvent,'modem_message',clicAPI.waitClic,{1,1,xmax,ymax,join}}
			actuDonne(message)
			tirage(message)
		end
		
		
	end
	premierLancement=false
end