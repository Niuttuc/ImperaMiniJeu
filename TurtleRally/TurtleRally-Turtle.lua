modem=peripheral.find('modem')
compass=peripheral.find('compass')
color=colors[string.lower(string.sub(os.getComputerLabel(),7,-1))] --recuperation de la couleur associe a la turtle dans son label
card={north=1,east=2,south=3,west=4}
invCard={'north','east','south','west'}
paresseux=true

garagePos={x=8,y=22,h=2}									--Position relative de l'entrée du garage
garageStartsDirection='south'						--Direction de la sortie pour les starts du garage par rapport a la route pour se garer.
sortieTrou='east'
directionxplus='west'								--Direction pour les coordonnees relatives du plateau
directionyplus='north'								--Juste xplus et yplus a remplir
													--si comme nous vous avez pas pense a ca avant...



for k,v in pairs(card) do							--On calcule les directions qui nous manque
	if math.abs(v-card[directionxplus])==2 then
		directionxmoins=k
	elseif math.abs(v-card[directionyplus])==2 then
		directionymoins=k
	end
	if math.abs(v-card[garageStartsDirection])==2 then
		garageCheckpointsDirection=k
	end
end



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
	if card[directionxplus]%2==1 then
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

function dirReldirCard(dirrel)
	corr={front=0,back=2,left=-1,right=1}
	currentDir=compass.getFacing()
	return invCard[(card[currentDir]+corr[dirrel])%5+math.floor((card[currentDir]+corr[dirrel])/5)]
end



function goTo(goalPos,keepDir)						--va a la coordonee goalPos, garde son orientation si keepDir est vraie
	startDir=compass.getFacing()
	currentPos=getTurtlePos()
	while goalPos.x~=currentPos.x or goalPos.y~=currentPos.y do
		if goalPos.x>currentPos.x then
			rotateToDirection(directionxplus)
		elseif goalPos.x<currentPos.x then
			rotateToDirection(directionxmoins)
		elseif goalPos.y>currentPos.y then
			rotateToDirection(directionyplus)
		elseif goalPos.y<currentPos.y then
			rotateToDirection(directionymoins)
		end
		forward()
		currentPos=getTurtlePos()
	end
	if keepDir then
		rotateToDirection(startDir)
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
	goTo(garagePos,false)
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
	periphs=peripheral.getNames()
	while not(peripheral.getType('back') and peripheral.getType('back')=='teleporter') do
		turtle.turnLeft()
	end
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
				end
			end
		end
		if mess=='trigoturn' then
			if paresseux then
				turtle.turnLeft()
			end
			modem.transmit(repFreq, color, 'fini')
		elseif mess=='clockturn' then
			if paresseux then
				turtle.turnRight()
			end
			modem.transmit(repFreq, color, 'fini')
		elseif mess=='turnback' then
			if paresseux then
				turtle.turnRight()
				turtle.turnRight()
			end
			modem.transmit(repFreq, color, 'fini')
		elseif type(mess)=='table' and mess[1]=='bouge' then
			if paresseux then
				goTo(mess[2],true)
			end
			modem.transmit(repFreq, color, 'fini')
		elseif type(mess)=='table' and mess[1]=='mort' then
			if paresseux then
				death(not(turtle.detectDown()))

				if mess[2]==garagePos then
					seGarer()
				end
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
		end
	end
end

waitForModem()