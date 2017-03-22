print("LOAD laser v0.02")
local laser=ahb.addPeripheral(config.get("laser"))
local lasers={}
function add(x,y,direction)
	x,y=joueur.calculPlusUn(x,y,direction)
	table.insert(lasers,{x=x,y=y,direction=direction})
end
function tires()
	for i=1,#lasers do
		tire(lasers[i].x,lasers[i].y,lasers[i].direction)
	end
end
function tire(x,y,direction)
	local tireDirection=''
	local tireX=config.get('x')
	local tireY=config.get('y')
	local tireZ=config.get('z')
	if config.get("orientation")=="WEST" then
		tireX=tireX+(x*-1)
		tireZ=tireZ+(y*-1)
		if direction=="MY" then
			tireDirection="SOUTH"
		elseif direction=="PX" then
			tireDirection="WEST"
		elseif direction=="PY" then
			tireDirection="NORTH"
		elseif direction=="MX" then
			tireDirection="EAST"
		end
	elseif config.get("orientation")=="NORTH" then
		tireX=tireX+(x*-1)
		tireZ=tireZ+(y)
		if direction=="MY" then
			tireDirection="EAST"
		elseif direction=="PX" then
			tireDirection="NORTH"
		elseif direction=="PY" then
			tireDirection="WEST"
		elseif direction=="MX" then
			tireDirection="SOUTH"
		end
	elseif config.get("orientation")=="EAST" then
		tireX=tireX+(x)
		tireZ=tireZ+(y)
		if direction=="MY" then
			tireDirection="SOUTH"
		elseif direction=="PX" then
			tireDirection="EAST"
		elseif direction=="PY" then
			tireDirection="NORTH"
		elseif direction=="MX" then
			tireDirection="WEST"
		end
	else
		tireX=tireX+(y*-1)
		tireZ=tireZ+(x)
		if direction=="MY" then
			tireDirection="WEST"
		elseif direction=="PX" then
			tireDirection="SOUTH"
		elseif direction=="PY" then
			tireDirection="EAST"
		elseif direction=="MX" then
			tireDirection="NORTH"
		end
	end
	--laser.pp.tire(tireX,tireY,tireZ,tireDirection,1)
	boucle=true
	while boucle do		
		if map.inmap(x,y) then
			toucher=joueur.presentGetId(x,y)
			if toucher==-1 then
				case=map.get(x,y)
				libre, ldegat=map.preAction(case,x,y) 
				if not(libre) then
					boucle=false
				end
			else
				joueur.degat(toucher)
				boucle=false
			end
		else
			boucle=false
		end
		x,y=joueur.calculPlusUn(x,y,direction)
	end
end