modem=peripheral.find('modem')
color={colors.brown,colors.yellow,colors.blue,colors.pink,colors.purple,colors.green}
colorcode={'c','4','b','6','a','d'}
selected={false,false,false,false,false,false}
selectedCommand={}
starts={}
for i=1,6 do
	if i%2==0 then
		starts[i]={x=2*i,y=16,direction='MY'}
	else
		starts[i]={x=2*i,y=17,direction='MY'}
	end
end

checkpoints={{x=9,y=2,direction='MX'},{x=3,y=4,direction='MX'},{x=13,y=6,direction='MY'},{x=8,y=9,direction='MY'}}
xmax,ymax=term.getSize()
function center(texte,mon,y)
	xmax=mon.getSize()
	if #texte>xmax then
		mon.setCursorPos(1,y)
		mon.write(string.sub(texte,1,xmax-3)..'...')
	else
		mon.setCursorPos(math.floor(xmax/2-#texte/2+0.5),y)
		mon.write(texte)
	end
end

function centerBlit(texte,mon,y,tx,bg)
	z=mon.getSize()
	if #texte>z then
		mon.setCursorPos(1,y)
		mon.blit(string.sub(texte,1,z-3)..'...',string.sub(tx,1,z),string.sub(bg,1,z))
	else
		mon.setCursorPos(math.floor(z/2-#texte/2+0.5),y)
		mon.blit(texte,tx,bg)
	end
end


function sendMess(turtles, mess)
	for i=1,#color do
		if colors.test(turtles, color[i]) then
			modem.transmit(color[i],10000,mess)
		end
	end
end
function turnLeft(turtles)
	sendMess(turtles,'gauche')
	return true
end
function turnRight(turtles)
	sendMess(turtles,'droite')
	return true
end
function sendHome(turtles)
	sendMess(turtles,'home')
	return true
end
function move(turtles)
	selectedStarts={}
	selectedCheckpoints={}
	for i=1,#color do
		if colors.test(turtles, color[i]) then
			term.clear()
			centerBlit('Objectif Turtle',term,1,'000000000ffffff','fffffffff'..string.rep(colorcode[i],6))
			term.setCursorPos(1,2)
			term.write('x=')
			x=read()
			term.setCursorPos(1,3)
			term.write('y=')
			y=read()
			term.setCursorPos(1,4)
			term.write('Direction=')
			dir=read()
			sendMess(color[i],{'bouge',{x=tonumber(x),y=tonumber(y),direction=string.upper(dir)}})
		end
	end
	return true
end
function enter(turtles)
	selectedStarts={}
	selectedCheckpoints={}
	for i=1,#color do
		if colors.test(turtles, color[i]) then
			actuEcranDest(i)
			if not(waitEcranDest(i)) then
				return false
			end
		end
	end
	return true
end

function actuEcranDest(i)
	term.clear()
	centerBlit('Objectif Turtle',term,1,'000000000ffffff','fffffffff'..string.rep(colorcode[i],6))
	for i=1,#starts do
		term.setCursorPos(1,i+1)
		if selectedStarts[i]==true then
			term.blit('Start '..tostring(i),'fffffff','5555555')
		elseif selectedStarts[i]==false then
			term.blit('Start '..tostring(i),'fffffff','7777777')
		else
			term.write('Start '..tostring(i))
		end
	end
	for i=1,#checkpoints do
		term.setCursorPos(1,i+1+#starts)
		if selectedCheckpoints[i]==true then
			term.blit('Checkpoint '..tostring(i),'ffffffffffff','555555555555')
		elseif selectedCheckpoints[i]==false then
			term.blit('Checkpoint '..tostring(i),'ffffffffffff','777777777777')
		else
			term.write('Checkpoint '..tostring(i))
		end
	end
	centerBlit('      ',term,ymax-2,'ffffff','444444')
	centerBlit('  OK  ',term,ymax-1,'ffffff','444444')
	centerBlit('      ',term,ymax,'ffffff','444444')
	term.setCursorPos(xmax,1)
	term.blit('X','f','e')
end

function waitEcranDest(i)
	while true do
		ev,button,x,y=os.pullEvent('mouse_click')
		term.setCursorPos(1,ymax-4)
		term.clearLine()
		if y>1 and y<=#starts+1 and x<=7 then
			for j=1, #starts do
				if j==y-1 and selectedStarts[j]~=false then selectedStarts[j]=true
				elseif selectedStarts[j]==true then selectedStarts[j]=nil end
			end
			for j=1,#checkpoints do
				if selectedCheckpoints[j]==true then selectedCheckpoints[j]=nil end
			end
			actuEcranDest(i)
		elseif y>#starts+1 and y<=#starts+#checkpoints+1 and x<=12 then
			for j=1, #starts do
				if selectedStarts[j]==true then selectedStarts[j]=nil end
			end
			for j=1,#checkpoints do
				if j==y-1-#starts and selectedCheckpoints[j]~=false then selectedCheckpoints[j]=true
				elseif selectedCheckpoints[j]==true then selectedCheckpoints[j]=nil end
			end
			actuEcranDest(i)
		elseif y>ymax-3 and x>=math.floor(xmax/2-#'  OK  '/2+0.5) and x<=math.floor(xmax/2-#'  OK  '/2+0.5)+6 then
			for j=1,#starts do
				if  selectedStarts[j]==true then
					objectif=starts[j]
					selectedStarts[j]=false
				end
			end
			for j=1,#checkpoints do
				if  selectedCheckpoints[j]==true then
					objectif=checkpoints[j]
					selectedCheckpoints[j]=false
				end
			end
			sendMess(color[i],{'onboard',objectif})
			return true
		elseif y==1 and x==xmax then
			return false
		end
	end
end

function actuTurtleLine(i)
	term.setCursorPos(1,i+1)
	if selected[i] then
		term.blit(string.rep(' ',xmax-1)..' ',string.rep('f',xmax-1)..'f',string.rep(colorcode[i],xmax-1)..'5')
	else
		term.blit(string.rep(' ',xmax-1)..' ',string.rep('f',xmax-1)..'f',string.rep(colorcode[i],xmax-1)..'e')
	end
	
end

function selectCommand(y)
	selectedCommand=commandes[y-#color-2]
	for i=1,#commandes do
		term.setCursorPos(1, 2+#color+i)
		if selectedCommand==commandes[i] then
			term.blit(commandes[i].name,string.rep('f',#commandes[i].name),string.rep('0',#commandes[i].name))
		else
			term.write(commandes[i].name)
		end
	end
end

function selectScreen()
	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.white)
	term.clear()
	center('Turtles:',term,1)
	for i=1,#color do
		actuTurtleLine(i)
	end
	center('Commandes:',term,2+#color)
	for i=1,#commandes do
		term.setCursorPos(1, 2+#color+i)
		if selectedCommand==commandes[i] then
			term.blit(commandes[i].name,string.rep('f',#commandes[i].name),string.rep('0',#commandes[i].name))
		else
			term.write(commandes[i].name)
		end
	end
	centerBlit('      ',term,ymax-2,'ffffff','444444')
	centerBlit('  OK  ',term,ymax-1,'ffffff','444444')
	centerBlit('      ',term,ymax,'ffffff','444444')	
end

function selectWait()
	while true do
		ev,button,x,y=os.pullEvent('mouse_click')
		term.setCursorPos(1,ymax-4)
		term.clearLine()
		if y>1 and y<=#color+1 then
			selected[y-1]=not(selected[y-1])
			actuTurtleLine(y-1)
		elseif y>#color+2 and y<=#color+2+#commandes and x<=#commandes[y-#color-2].name then
			selectCommand(y)
		elseif y>ymax-3 and x>=math.floor(xmax/2-#'  OK  '/2+0.5) and x<=math.floor(xmax/2-#'  OK  '/2+0.5)+6 then
			if selectedCommand~={} then
				turtles=0
				for i=1,#color do
					if selected[i]==true then
						turtles=colors.combine(turtles, color[i])
					end
				end
				if selectedCommand.func then
					Envoie=selectedCommand.func(turtles)
				else
					Envoie=false
				end
				selectScreen()
				if Envoie then 
					centerBlit('Commande envoyee',term,ymax-4,'eeeeeeeeeeeeeeee','ffffffffffffffff')
				end
			end

		end
	end
end
function endort()
	sendMess(turtles,'paresseux')
	return true
end
function reveil()
	sendMess(turtles,'reveil')
	return true
end
commandes={{name='Home',func=sendHome},{name='Entre en jeu',func=enter},{name='Deplace',func=move},{name='Tourne Horaire',func=turnRight},{name='Tourne anti-Horaire',func=turnLeft},{name='Paresseux',func=endort},{name='Reveil',func=reveil}}
selectScreen()
selectWait()