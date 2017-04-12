args={...}
os.loadAPI("ahb")
local content = http.get(args[0])
data=textutils.unserialise(content.readAll())
config=ahb.config("majs",{liste={typ="table"}})
liste=""
for prog, preConfig in pairs(data) do
	if config.liste[prog]==nil then	
		ahb.configTab('majs','liste','add',prog,preConfig.plateforme)
	else
		ahb.configTab("majs",'liste','maj',prog,preConfig.plateforme)
	end
	configFile=ahb.configFileFc("maj"..prog)
	if fs.exists(configFile) then
		fs.delete(configFile)
	end
	remove(preConfig.plateforme)
	file=fs.open(configFile,'w')
	file.write(textutils.serialize(preConfig))
	file.close()
	liste=liste.." "..prog
end
shell.run("maj"..liste)