print("Turtle charge version Git v3.4")
modem=peripheral.find('modem')
compass=peripheral.find('compass')
color=colors[string.lower(string.sub(os.getComputerLabel(),7,-1))] --recuperation de la couleur associe a la turtle dans son label
card={north=1,east=2,south=3,west=4}
invCard={'north','east','south','west'}
paresseux=true

garagePos={x=8,y=22,h=2,diretion='PY'}									--Position relative de l'entrée du garage
garageStartsDirection='south'						--Direction de la sortie pour les starts du garage par rapport a la route pour se garer.
sortieTrou='east'
px='west'								--Direction pour les coordonnees relatives du plateau
py='north'								--Juste xplus et yplus a remplir
													--si comme nous vous avez pas pense a ca avant...



for k,v in pairs(card) do							--On calcule les directions qui nous manque
	if math.abs(v-card[px])==2 then
		mx=k
	elseif math.abs(v-card[py])==2 then
		my=k
	end
	if math.abs(v-card[garageStartsDirection])==2 then
		garageCheckpointsDirection=k
	end
end
cardPlateau={[px]=1,[py]=2,[mx]=3,[my]=4}
cardNamePlateau={px=px,py=py,mx=mx,my=my}

--Forme des coordonnees: {x=coordonee en x relatif,y=coordonee en y relatif}
--L'entree du garage doit etre libre d'acces selon l'AXE DES Y et un niveau au dessus du plateau


function forward()
	while not(turtle.forward()) do
		bool,block=turtle.inspect()
		while card[compass.getFacing()]>=3 and block.name=='ComputerCraft:CC-TurtleAdvanced' and not(turtle.up())   do
			sleep(1.5)
		end
		while card[compass.getFacing()]>=3 and not(turtle.down())  do
			sleep(1.5)
		end
		sleep(1)
	end
end

function down()
	while not(turtle.down()) do
		sleep(1)
	end
end
function up()										--..., up and away!
	while not(turtle.up()) do
		sleep(1)
	end
end


function getTurtlePos()								--recupere les coordonnees relatives de la turtle, s'adapte a l'orientation
	local currenty,h,currentx
	if card[px]%2==1 then
		currenty,h,currentx=gps.locate()
	else
		currentx,h,currenty=gps.locate()
	end
	return {x=currentx,y=currenty,h=h}
end


function rotateToDirection(dir)						--Tourne, tourne, Turtle
	if (card[compass.getFacing()]-card[dir])%4==1 then
		turtle.turnLeft()
	elseif (card[compass.getFacing()]-card[dir])%4==2 then
		turtle.turnLeft()
		turtle.turnLeft()
	elseif (card[compass.getFacing()]-card[dir])%4==3 then
		turtle.turnRight()
	end
end
function rotateToDirPlateau(dirPlateau)						--Tourne, tourne, Turtle
	if (cardPlateau[compass.getFacing()]-cardPlateau[cardNamePlateau[dirPlateau]])%4==1 then
		turtle.turnLeft()
	elseif (cardPlateau[compass.getFacing()]-cardPlateau[cardNamePlateau[dirPlateau]])%4==2 then
		turtle.turnLeft()
		turtle.turnLeft()
	elseif (cardPlateau[compass.getFacing()]-cardPlateau[cardNamePlateau[dirPlateau]])%4==3 then
		turtle.turnRight()
	end
end

function dirReldirCard(dirrel)
	corr={front=0,back=2,left=-1,right=1}
	currentDir=compass.getFacing()
	return invCard[(card[currentDir]+corr[dirrel])%5+math.floor((card[currentDir]+corr[dirrel])/5)]
end



function goTo(goalPos)						--va a la coordonee goalPos, garde son orientation si keepDir est vraie
	startDir=compass.getFacing()
	currentPos=getTurtlePos()
	if math.abs(goalPos.x-currentPos.x)+math.abs(goalPos.y-currentPos.y)==1 then
		print("Juste 1")
		if goalPos.x>currentPos.x then
			if (card[startDir]-card[px])%4==2 then
				if turtle.back() then
					return
				end
			end
		elseif goalPos.x<currentPos.x then
			if (card[startDir]-card[mx])%4==2 then
				if turtle.back() then
					return
				end
			end
		elseif goalPos.y>currentPos.y then
			if (card[startDir]-card[py])%4==2 then
				if turtle.back() then
					return
				end
			end
		elseif goalPos.y<currentPos.y then
			if (card[startDir]-card[my])%4==2 then
				if turtle.back() then
					return
				end
			end
		end		
	end
	while goalPos.x~=currentPos.x or goalPos.y~=currentPos.y do
		if goalPos.x>currentPos.x then
			rotateToDirection(px)
		elseif goalPos.x<currentPos.x then
			rotateToDirection(mx)
		elseif goalPos.y>currentPos.y then
			rotateToDirection(py)
		elseif goalPos.y<currentPos.y then
			rotateToDirection(my)
		end
		forward()
		currentPos=getTurtlePos()
	end
	if goalPos.direction then
		rotateToDirPlateau(goalPos.direction)
	end
end


function death(trou)								--si trou est a true (j'ai pas pu m'en empecher :D), passe par le bas
	h=getTurtlePos().h								-- et se rend au garage, sinon, se rend au garage
	if trou and h==1 then									
		down()
		down()
		rotateToDirection(sortieTrou)
		forward()
		forward()
		forward()
	elseif h==0 then
		down()
		rotateToDirection(sortieTrou)
		forward()
		forward()
		forward()
	elseif h==-1 then
		rotateToDirection(sortieTrou)
		forward()
		forward()
		forward()
	elseif not(trou) and h==1 then
		up()
	end
	if trou then
		up()
		up()
		up()
	end
	pos=getTurtlePos()
	goTo(garagePos)
	rotateToDirection(garageCheckpointsDirection)
	pos=getTurtlePos()
	while pos.h<garagePos.h do
		up()
		pos=getTurtlePos()
	end
	pos=getTurtlePos()
	while pos.h>garagePos.h do
		down()
		pos=getTurtlePos()
	end
	print('death done')
end



function deathDest(trou,dest)						--si trou est a true (j'ai pas pu m'en empecher :D), passe par le bas
	h=getTurtlePos().h								-- et se rend au garage, sinon, se rend au garage
	if trou and h==1 then									
		down()
		down()
		rotateToDirection(sortieTrou)
		forward()
		forward()
		forward()
	elseif h==0 then
		down()
		rotateToDirection(sortieTrou)
		forward()
		forward()
		forward()
	elseif h==-1 then
		rotateToDirection(sortieTrou)
		forward()
		forward()
		forward()
	elseif not(trou) and h==1 then
		up()
	end
	if trou then
		up()
		up()
		up()
	end
	pos=getTurtlePos()
	goTo(dest)
	turtle.down()
	pos=getTurtlePos()
end

function enterTheGame(destination)					--quitte le gararge et va se placer sur le depart destination
	forward()
	forward()
	rotateToDirection(garageStartsDirection)
	while turtle.detectDown() do
		turtle.forward()
	end
	forward()
	goTo(destination)
	turtle.down()
end

function seGarer()									--la turtle se gare depuis le teleporter du garage
	forward()
	turtle.turnLeft()
	bool,blockInfo=turtle.inspectDown()
	while blockInfo.name~='minecraft:wool' do
		turtle.forward()
		bool,blockInfo=turtle.inspectDown()
	end
	turtle.turnRight()
	while true do
		for i=1,3 do
			bool,blockInfo=turtle.inspectDown()
			if bool then
				print(blockInfo.name..' ',color,' ',blockInfo.metadata)
			end
			if bool and blockInfo.name=='minecraft:wool' and color==2^blockInfo.metadata then
				turtle.turnLeft()
				if turtle.forward() then
					while (turtle.getFuelLimit()-turtle.getFuelLevel())>80 do
						turtle.suck(math.min(math.floor((turtle.getFuelLimit()-turtle.getFuelLevel()/80)),64))
						turtle.refuel()
					end
					turtle.turnLeft()
					turtle.turnLeft()
					return true
				else
					turtle.turnRight()
				end
			end
			bool,blockInfo=turtle.inspect()
			while not(turtle.forward()) and not(bool and blockInfo.name=='minecraft:stone') do
				sleep(1)
			end
		end
		bool,blockInfo=turtle.inspectDown()
		if bool then
			print(blockInfo.name..' ',color,' ',blockInfo.metadata)
		end
		if bool and blockInfo.name=='minecraft:wool' and color==2^blockInfo.metadata then
			turtle.turnLeft()
			if turtle.forward() then
				while (turtle.getFuelLimit()-turtle.getFuelLevel())>80 do
					turtle.suck(math.min(math.floor((turtle.getFuelLimit()-turtle.getFuelLevel()/80)),64))
					turtle.refuel()
				end
				turtle.turnLeft()
				turtle.turnLeft()
				return true
			else
				turtle.turnRight()
			end
		end
		turtle.turnRight()
		forward()
		forward()
		turtle.turnRight()
	end
end

function goHome()										-- La turtle va se garer
	bool,blockInfo=turtle.inspectDown()
	if not(bool and blockInfo.name=='minecraft:wool' and color==2^blockInfo.metadata) then
		death(not(turtle.detectDown()),garagePos)
		seGarer()
	end
end



function waitForModem()
	modem.open(color)
	while true do
		ev,side,freq,repFreq,mess,dis=os.pullEvent('modem_message')
		if type(mess)=='string' then
			mess=string.lower(mess)
			
		elseif type(mess)=='table' then
			for i=1,#mess do
				if type(mess[i])=='string' then
					mess[i]=string.lower(mess[i])
				elseif type(mess[i])=='table' then
					for k,v in pairs(mess[i]) do
						if type(v)=='string' then
							mess[i][k]=string.lower(v)
						end
					end
				end
			end
		end
		if type(mess)=='table' and mess[1]=='tourne' then
			if paresseux then
				rotateToDirPlateau(mess[2])
			end
			modem.transmit(repFreq, color, 'fini')
		elseif type(mess)=='table' and mess[1]=='bouge' then
			if paresseux then
				goTo(mess[2])
			end
			modem.transmit(repFreq, color, 'fini')
		elseif type(mess)=='table' and mess[1]=='mort' and #mess==1 then
			if paresseux then
				pos=getTurtlePos()
				booll=(not(turtle.detectDown()) and pos.x>0 and pos.x<15 and pos.y>0 and pos.y<19)
				death(booll)
				seGarer()
			end
			modem.transmit(repFreq, color, 'fini')
		elseif type(mess)=='table' and mess[1]=='mort' and #mess==2 then
			if paresseux then
				pos=getTurtlePos()
				booll=(not(turtle.detectDown()) and pos.x>0 and pos.x<15 and pos.y>0 and pos.y<19)
				deathDest(booll,mess[2])
			end
			modem.transmit(repFreq, color, 'fini')
		elseif mess=='home' then
			goHome()
		elseif mess=='paresseux' then
			paresseux=false
			modem.transmit(repFreq, color, 'zzzzzz')
		elseif mess=='reveil' then
			paresseux=true
			modem.transmit(repFreq, color, 'Hein? Quoi?')
		elseif type(mess)=='table' and mess[1]=='onboard' then
			if paresseux then
				enterTheGame(mess[2])
			end
			modem.transmit(repFreq, color, 'fini')
		else
			print("Pas de config ")
			print(mess)
		end
	end
end

waitForModem()
