-- Verification et connection a un peripherique
function addPeripheral(id)
	if not(type(id)=="string") then
		error(tostring(id)..' nom perif incorrect')
	end
	if not(peripheral.isPresent(id)) then
		error(id..' non connecte')
		shell.exit()
	end
	return {
		id=id,
		pp=peripheral.wrap(id)
	}
end

fichier={
	sauvegarde=function(nomDuFichier,valeurAsauvgarder)
		local file=fs.open(nomDuFichier,"w")
		file.write(valeurAsauvgarder)
		file.close()
	end,
	charge=function(nomDuFichier)
		if not(fs.exists(nomDuFichier)) then return nil end
		local file=fs.open(nomDuFichier,"r")
		tmp=file.readAll()
		file.close()
		return tmp
	end
}

function formatChiff(c)
	local mill=math.floor(c/1000)
	if mill==0 then
		return tostring(math.floor(c))
	else
		local unit=math.floor(c-(mill*1000))
		if unit<10 then
			return mill.." 00"..unit
		elseif unit<100 then
			return mill.." 0"..unit
		else
			return mill.." "..unit
		end
	end
end


-- return key of the element in table, or nil
function isIn(element,table)						
  for key,val in pairs(table) do
    if val==element then
      return key
    end
  end
  return nil
end

-- Centre le "texte", dans le moniteur ou fenetre "mon", a la hauteur "y"
function center(texte,mon,y)
    x=mon.getSize()
    if #texte>x then
        mon.setCursorPos(1,y)
        mon.write(string.sub(texte,1,x-3)..'...')
    else
        mon.setCursorPos(math.floor(x/2-#texte/2+0.5),y)
        mon.write(texte)
    end
end

-- Centre avec la fonction blit avec la posibilite d'utilise l'api colors
colorsBlit={
            [colors.white]='0',
            [colors.orange]='1',
            [colors.magenta]='2',
            [colors.lightBlue]='3',
            [colors.yellow]='4',
            [colors.lime]='5',
            [colors.pink]='6',
            [colors.gray]='7',
            [colors.lightGray]='8',
            [colors.cyan]='9',
            [colors.purple]='a',
            [colors.blue]='b',
            [colors.brown]='c',
            [colors.green]='d',
            [colors.red]='e',
            [colors.black]='f'
            }
function centerBlit(texte,mon,y,tx,bg)
    if type(tx)=='number' and colorsBlit[tx] then
        tx=string.rep(colorsBlit[tx],#texte)
    end
    if type(bg)=='number' and colorsBlit[bg] then
        bg=string.rep(colorsBlit[bg],#texte)
    end    
    z=mon.getSize()
    if #texte>z then
        mon.setCursorPos(1,y)
        mon.blit(string.sub(texte,1,z-3)..'...',string.sub(tx,1,z),string.sub(bg,1,z))
    else
        mon.setCursorPos(math.floor(z/2-#texte/2+0.5),y)
        mon.blit(texte,tx,bg)
    end
end


configFileFc=function(programName)
	return './config123/'..programName.."Config"
end
-- config("NomDuProg",{
-- 	nomVariable={
--    typ="string", -- choix, choix2, side, coord, couleur, boolean, table
--    info="Information complementaire",
--    defaut=""  -- proposition
--    choix={"choix 1","choix 2"} -- si typ choix
--    choix={c1="choix 1",c2="choix 2"} -- si typ choix2 
--  }
-- })
function config(programName,pConfig)
    local configFile=configFileFc(programName)
	local config={}
	local ok=true
    if not(fs.isDir('config123')) then
        fs.makeDir('config123')
    end
	if not(fs.exists(configFile)) then
		ok=false
	else
		file=fs.open(configFile,'r')
		config=textutils.unserialize(file.readAll())
		file.close()
		for key,data in pairs(pConfig) do
			if config[key]==nil then
				ok=false
			end
		end
	end
	
    if not(ok) then
        term.clear()
        term.setCursorPos(1,1)
        print('Pas de fichier de config trouve')
        print('Creation de fichier de config ')
        sleep(0.5)
        
        for key,data in pairs(pConfig) do
			if config[key]==nil then
				term.setBackgroundColor(colors.white)
				term.setTextColor(colors.black)
				term.clear()
				term.setCursorPos(1,1)				
				if data.info~=nil then
					question="CONF : "..data.info
				else
					question="CONF : "..key
				end				
				print(question)
				
				if data.typ=="side" then
					data.choix={"front","back","left","right","top","bottom","autre"}
				end
				if data.typ=="coord" then
					data.choix={'EAST','WEST','SOUTH','NORTH','UP','DOWN'}
					data.typ="choix"
				end
				if data.typ=="couleur" then
					data.choix={
						[colors.white]="white",
						[colors.orange]="orange",	
						[colors.magenta]="magenta",
						[colors.lightBlue]="lightBlue",	
						[colors.yellow]="yellow",
						[colors.lime]="lime",
						[colors.pink]="pink",
						[colors.gray]="gray",
						[colors.lightGray]="lightGray",
						[colors.cyan]="cyan",
						[colors.purple]="purple",
						[colors.blue]="blue",
						[colors.brown]="brown",
						[colors.green]="green",
						[colors.red]="red",
						[colors.black]="black"
					}
				end
				if data.typ=="boolean" then
					data.choix={
						[true]="true",
						[false]="false"
					}
					data.typ="choix2" -- 
				end
				
				if data.typ=="string" then
					if data.defaut~=nil then
						term.setCursorPos(1,3)
						term.write("Si vide defaut : "..data.defaut)
					end
					term.setCursorPos(1,2)
					local answer=read()
					if data.defaut~=nil and answer=='' then
						config[key]=data.defaut
					else
						config[key]=answer
					end
					
				elseif data.typ=="choix" or data.typ=="choix2" or data.typ=="couleur" or data.typ=="side" then
					j=1
					for ck,cv in pairs(data.choix) do
						if data.typ=="couleur" then
							term.setBackgroundColor(ck)
						end
						term.setCursorPos(1,j+1)
						term.write(cv)
						j=j+1
					end
					local bool=true
					while bool do
						ev,button,x,y=os.pullEvent("mouse_click")
						j=1
						for ck,cv in pairs(data.choix) do
							if y==j+1 then
								if data.typ=="choix" then
									config[key]=cv
								elseif data.typ=="side" then
									if cv=="autre" then
										term.setCursorPos(1,10)
										local answer=read()
										config[key]=answer
									else
										config[key]=cv
									end
								else -- choix2 et couleur
									config[key]=ck
								end
								bool=false
							end
							j=j+1
						end
					end					
				elseif data.typ=="table" then
					config[key]={}
				end				
			end
        end
		term.setBackgroundColor(colors.black)
		term.setTextColor(colors.white)
		term.clear()
		term.setCursorPos(1,1)
		file=fs.open(configFile,'w')
		file.write(textutils.serialize(config))
        file.close()
    end   
    return config
end
function configTab(programName,var,action,key,value)
	local configFile=configFileFc(programName)
	if not(fs.exists(configFile)) then
		error('ahb.configTab doit etre utiliser apres ahb.config')
	else
		file=fs.open(configFile,'r')
		config=textutils.unserialize(file.readAll())
		file.close()
		if action=='add' then
			if key==false then
				table.insert(config[var],value)
			else
				config[var][key]=value
			end
		elseif action=='maj' then
			config[var][key]=value
		elseif action=='remove' then
			if not(key==false) then
				table.remove(config[var],key)
			elseif not(value==false) then
				key=isIn(value,config[var])
				if key then
					table.remove(config[var],key)
				end
			else
				table.remove(config[var])
			end	
		end
		fs.delete(configFile)
		file=fs.open(configFile,'w')
		file.write(textutils.serialize(config))
        file.close()
		return config[var]
	end
end

function baseConverter (toConvert,baseOri,baseDest)
  if type(toConvert)=='number' then
    toConvert=tostring(toConvert)
  end
  local convertList={}
  for i=1,#toConvert do
    if tonumber(string.sub(toConvert,i,i)) then
      convertList[i]=tonumber(string.sub(toConvert,i,i))
    else
      convertList[i]=string.byte(string.sub(toConvert,i,i))-87
    end
  end
 
  local convertDec=0
  for i=1,#convertList do
    convertDec=convertDec+convertList[i]*baseOri^(#convertList-i)
  end
  local bool=true
  local newList={}
  local newDec=0
  while not(convertDec==newDec) do
    local temp=convertDec-newDec
    i=0
    while temp>=baseDest do
      temp=(temp-temp%baseDest)/baseDest
      i=i+1
    end
    newList[i]=temp
    newDec=newDec+temp*baseDest^i
  end
  local newString=""
  for i=table.maxn(newList),0,-1 do
    if newList[i] then
      if newList[i]>9 then
        newString=newString..string.char(87+newList[i])
      else
        newString=newString..tostring(newList[i])
      end
    else
      newString=newString.."0"
    end
  end
  return newString,tonumber(newString)
end