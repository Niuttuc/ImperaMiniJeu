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
local mesActions={}
function affWin(win)
	currentWin.setVisible(false)
	currentWin=win
	currentWin.setVisible(true)
end
function quit(x,y)
	modem.transmit(84,color+1,'LEAVE')
	thingsToDo={os.pullEvent,'modem_message'}
end
function join(x,y)
  	modem.transmit(84,color+1,'JOIN')
	thingsToDo={os.pullEvent,'modem_message'}
end
function actuDonne(data)
	vie=data.vie	
	if vie==0 then windows.vie.setBackgroundColor(colors.black)
	elseif vie==1 then windows.vie.setBackgroundColor(colors.red)
	elseif vie==2 then windows.vie.setBackgroundColor(colors.orange)
	else windows.vie.setBackgroundColor(colors.green)	
	end
	windows.vie.clear()
	windows.vie.setCursorPos(1,1)
	if vie==0 then windows.vie.write("MORT")
	elseif vie==1 then windows.vie.write("1 vie")
	else
		windows.vie.write(vie.." vies")
	end		
	
	if coeur>5 then windows.coeur.setBackgroundColor(colors.lime)
	elseif coeur==5 then windows.coeur.setBackgroundColor(colors.yellow)
	else windows.coeur.setBackgroundColor(colors.red)
	end
	coeur=data.coeur
	windows.coeur.clear()
	windows.coeur.setCursorPos(1,1)
	texte=coeur.." coeur"
	if coeur>1 then
		texte=texte.."s"
	end
	windows.coeur.write(texte)
	
	
	checkpoint=data.checkpoint
	windows.etape.clear()
	windows.etape.setCursorPos(1,1)
	if not(checkpoint==0) then		
		windows.etape.write("Etape : "..checkpoint)
	else
		windows.etape.write("Depart")
	end
end
local derTirage={}
function tirage()
	mesActions={}
	windows.playWindow.clear()
	local tirageA={}
	for k,v in pairs(choices) do
		for i=1, v.weight do
			table.insert(tirageA,k)
		end
	end
	derTirage={}
	for i=1, coeur do
		windows.listColumn.setCursorPos(1,i)
		index=math.random(#tirageA)
		table.insert(derTirage,tirageA[index])
		table.remove(tirageA,index)
	end
	actuAffichage()
	affWin(windows.playWindow)
end
function choixClic(x,y)
	error("SALUT")
end
function actuAffichage()
	windows.listColumn.clear()
	for i=1, #derTirage do
		windows.listColumn.write(choices[derTirage[i]].nomListe)
	end
	windows.separateColumn.clear()
	for i=1,5 do
		if coeur>=i then 
			windows.separateColumn.setTextColor(colors.black)
		else
			windows.separateColumn.setTextColor(colors.red)
		end
		windows.separateColumn.setCursorPos(1,i)
		windows.separateColumn.write(i)
	end
	windows.choiceColumn.clear()
	for i=1,5 do
	
	end
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
			thingsToDo={os.pullEvent,'modem_message',clicAPI.waitClic,{1,9,xmax,ymax,choixClic}}
			actuDonne(message)
			tirage(message)
		end
		
		
	end
	premierLancement=false
end