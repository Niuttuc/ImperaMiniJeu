-- maj     	  Met a jour tous les programmes + utilitaire
-- maj NOM1, NOM2    Met a jour le programme NOM
function majUtile()
	if fs.exists("ahb") then
		fs.delete("ahb")
	end
	local content = http.get("https://raw.githubusercontent.com/Niuttuc/ImperaMiniJeu/master/Common/Advanced%20Home%20Base%20(ahb).lua")
	local file = fs.open("ahb","w")
	file.write(content.readAll())
	file.close()
end
function majPastBin(nom)
	config=ahb.config("maj"..nom,{
		pastebin={typ="string"},
		prog={typ="string",defaut=nom}
	})
	if fs.exists(config.prog) then
		fs.delete(config.prog)
	end
	print("PasteBin "..config.pastebin.." vers "..config.prog)
	local content = http.get("https://pastebin.com/raw/"..config.pastebin)
	local file = fs.open(config.prog,"w")
	file.write(content.readAll())
	file.close()
end
function majGithub(nom)	
	configGit=ahb.config("gitHubDef",{
		user={typ="string",info="utilisateur github.com par default"},
		repository={typ="string",info="nom repository github.com par default"},
		branch={typ="string",info="branch github.com par default",defaut="master"}
	})
	config=ahb.config("maj"..nom,{
		user={typ="string",info="utilisateur github.com ",defaut=configGit.user},
		repository={typ="string",info="nom repository github.com",defaut=configGit.repository},
		branch={typ="string",info="branch github.com",defaut=configGit.branch},
		file={typ="string",info="fichier sur github.com"},
		prog={typ="string",defaut=nom}
	})
	if fs.exists(config.prog) then
		fs.delete(config.prog)
	end
	print("GitHub "..config.repository.." "..config.file.." vers "..config.prog)
	local content = http.get("https://raw.githubusercontent.com/"..config.user.."/"..config.repository.."/"..config.branch.."/"..config.file.."?t"..s.day()..os.time())
	local file = fs.open(config.prog,"w")
	file.write(content.readAll())
	file.close()
end
local args={ ... }
if (#args == 0) then	
	majUtile()
	os.loadAPI("ahb")
	config=ahb.config("majs",{liste={typ="table"}})
	for prog, site in pairs(config.liste) do
		if site=="pastebin" then
			majPastBin(prog)
		elseif site=="github" then
			majGithub(prog)
		else
			error("Site non config "..prog)
		end
	end
else 
	if not(fs.exists("ahb")) then
		majUtile()
	end
	for i, prog in pairs(args) do
		if prog=='ahb' then
			majUtile()
		else
			os.loadAPI("ahb")
			config=ahb.config("majs",{liste={typ="table"}})
			if config.liste[prog]==nil then	
				term.setBackgroundColor(colors.white)
				term.setTextColor(colors.black)
				term.clear()
				term.setCursorPos(1,1)
				term.write("Nouveau programe "..prog)
				term.setCursorPos(2,2)
				term.write("Pastebin")
				term.setCursorPos(2,3)
				term.write("GitHub")
				local bool=true
				while bool do
					ev,button,x,y=os.pullEvent("mouse_click")
					if y==2 then
						ahb.configTab('majs','liste','add',prog,"pastebin")
						config.liste[prog]="pastebin"
						bool=false
					elseif y==3 then
						ahb.configTab('majs','liste','add',prog,"github")
						config.liste[prog]="github"
						bool=false
					end				
				end
			end
			if config.liste[prog]=="pastebin" then
				majPastBin(prog)
			elseif config.liste[prog]=="github" then
				majGithub(prog)
			else
				error("Site non config "..args[1])
			end
		end
	end
end