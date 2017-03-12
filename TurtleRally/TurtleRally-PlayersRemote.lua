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
local preActions={}
local tours={-1,-1,-1,-1,-1}
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
	
	coeur=data.coeur
	if coeur>5 then windows.coeur.setBackgroundColor(colors.lime)
	elseif coeur==5 then windows.coeur.setBackgroundColor(colors.yellow)
	else windows.coeur.setBackgroundColor(colors.red)
	end	
	windows.coeur.clear()
	windows.coeur.setCursorPos(2,1)
	texte=coeur.." coeur"
	if coeur>1 then
		texte=texte.."s"
	end
	if coeur<10 then
		texte=" "..texte
	end
	windows.coeur.write(texte)
	
	
	checkpoint=data.checkpoint
	windows.etape.clear()
	windows.etape.setCursorPos(2,1)
	if not(checkpoint==0) then		
		windows.etape.write("Etape "..checkpoint)
	else
		windows.etape.write("Depart")
	end
end
local derTirage={}
function tirage(data)
	preActions=data.actions
	mesActions={}
	local tirageA={}
	for k,v in pairs(choices) do
		for i=1, v.weight do
			table.insert(tirageA,k)
		end
	end
	derTirage={}
	for i=1, coeur do
		index=math.random(#tirageA)
		table.insert(derTirage,tirageA[index])
		table.remove(tirageA,index)
	end
	actuAffichage(true)
end
function choixClic(x,y)
	local continue=true
	if y>8 then
		if #mesActions==coeur or #mesActions==5 then
			if coeur<5 then
				for i=1,5 do
					if coeur>=i then
					else
						mesActions[i]=preActions[i]
					end
				end
			end
			local dodo=false
			if y>14 then
				dodo=true
			end
			modem.transmit(84,color+1,{actions=mesActions,dodo=dodo})
			continue=false
		else
			if y-8<=#derTirage then
				table.insert(mesActions,derTirage[y-8])
				table.remove(derTirage,y-8)
			end
		end
	else
		if y-2<=#mesActions then
			table.insert(derTirage,mesActions[y-2])
			table.remove(mesActions,y-2)
		end
	end
	actuAffichage(continue)
	if continue then
		thingsToDo={os.pullEvent,'modem_message',clicAPI.waitClic,{1,3,xmax,18,choixClic}}
	else
		thingsToDo={os.pullEvent,'modem_message'}
	end
end
function actuAffichage(continue)
	affWin(windows.playWindow)
	windows.playWindow.clear()
	windows.vie.redraw()
	windows.coeur.redraw()
	windows.etape.redraw()
	
	windows.separateColumn.clear()
	for i=1,5 do
		if tours[i]==true then
			windows.separateColumn.setTextColor(colors.green)
		elseif tours[i]==false then
			windows.separateColumn.setTextColor(colors.red)
		elseif coeur>=i then 
			windows.separateColumn.setTextColor(colors.black)
		else
			windows.separateColumn.setTextColor(colors.red)
		end
		windows.separateColumn.setCursorPos(1,i)
		windows.separateColumn.write(i)
	end
	windows.choiceColumn.clear()
	local first=true
	local combien=0
	for i=1,5 do
		windows.choiceColumn.setCursorPos(1,i)
		if coeur>=i then 			
			if type(mesActions[i])=='nil' then
				if first then
					first=false
					windows.choiceColumn.setTextColor(colors.white)
					windows.choiceColumn.write("Prochain choix")
				else
					windows.choiceColumn.setTextColor(colors.black)
					windows.choiceColumn.write("a choisir")
				end
			else
				combien=combien+1
				if tours[i]==true then
					windows.choiceColumn.setTextColor(colors.green)
				elseif tours[i]==false then
					windows.choiceColumn.setTextColor(colors.red)
				else
					windows.choiceColumn.setTextColor(colors.black)
				end
				windows.choiceColumn.write(choices[mesActions[i]].nomListe)
			end
		else
			combien=combien+1
			if tours[i]==true then
				windows.choiceColumn.setTextColor(colors.green)
			elseif tours[i]==false then
				windows.choiceColumn.setTextColor(colors.red)
			else
				windows.choiceColumn.setTextColor(colors.black)
			end
			windows.choiceColumn.write(choices[preActions[i]].nomListe)			
		end
	end
	if combien~=5 then
		windows.listColumn.clear()
		for i=1, #derTirage do
			windows.listColumn.setCursorPos(1,i)
			windows.listColumn.write(choices[derTirage[i]].nomListe)
		end	
	else
		if continue then
			windows.validerBouton.redraw()
			windows.sleepBt.redraw()
		end
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
		elseif message.action=="DODO" then
			affWin(windows.veille)
			thingsToDo={os.pullEvent,'modem_message'}
		elseif message.action=="LOBBY" then
			affWin(windows.beforeGame)
			thingsToDo={os.pullEvent,'modem_message',clicAPI.waitClic,{xmax-6,1,xmax,3,quit}}
		elseif message.action=="TOOLATE" then
			affWin(windows.gameInProgress)
			thingsToDo={os.pullEvent,'modem_message'}
		elseif message.action=="CHOIX" then
			tours={-1,-1,-1,-1,-1}
			thingsToDo={os.pullEvent,'modem_message',clicAPI.waitClic,{1,3,xmax,ymax,choixClic}}
			actuDonne(message)
			tirage(message)
		elseif message.action=="WAITPLAYER" then
			tours={-1,-1,-1,-1,-1}
			actuDonne(message)
			preActions=message.actions
			mesActions=message.actions
			actuAffichage(false)
			thingsToDo={os.pullEvent,'modem_message'}
		elseif message.action=="infoTour" then
			tours[message.tour]=message.status
			actuDonne(message)
			actuAffichage(false)			
			thingsToDo={os.pullEvent,'modem_message'}
		else 
			thingsToDo={os.pullEvent,'modem_message'}
		end
	end
	premierLancement=false
end