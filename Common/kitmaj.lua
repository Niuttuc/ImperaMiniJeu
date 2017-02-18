-- maj     	  Met a jour tous les programmes + utilitaire
-- maj NOM    Met a jour le programme NOM
function majUtile()
	if fs.exists("ahb") then
		--fs.delete("ahb")
	end
	--shell.run("pastebin","get","WAUmws90","ahb")
end
function majProg(nom)
	config=ahb.config("maj"..nom,{
		pastebin={typ="string"},
		prog={typ="string",defaut="startup"}
	})
	if fs.exists(config.prog) then
		fs.delete(config.prog)
	end
	shell.run("pastebin","get",config.pastebin,config.prog)
	
end
local args={ ... }
if (#args == 0) then	
	majUtile()
	os.loadAPI("ahb")
	config=ahb.config("majs",{liste={typ="table"}})
	for prog, ok in pairs(config.liste) do
		majProg(prog)
	end
else 
	if not(fs.exists("ahb")) then
		majUtile()
	end
	if args[1]=='ahb' then
		majUtile()
	else
		os.loadAPI("ahb")
		config=ahb.config("majs",{liste={typ="table"}})
		if config.liste[args[1]]==nil then
			print("Nouveau programe "..args[1])
			ahb.configTab('majs','liste','add',args[1],true)
		end
		majProg(args[1])
	end
end