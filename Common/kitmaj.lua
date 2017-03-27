-- Utilisation dans la console :
-- "maj"     	  	Met a jour tous les programmes + utilitaire
-- "maj NOM1, NOM2" Met a jour et/ou ajouute le programme NOM

-- Par Adsl-Houba ( Samuel Mandonnaud )
-- www.youtube.com/user/MrAdslHouba www.adslhouba.fr

-- Remplace le contenu du fichier "fichier" par le contenu de la page "url"
function majFichierParUrl(fichier,url)
	if fs.exists(fichier) then
		fs.delete(fichier)
	end
	local content = http.get(url)
	local file = fs.open(fichier,"w")
	file.write(content.readAll())
	file.close()
end

-- Recupere le programme ahb
function majAHB()
	majFichierParUrl("ahb","https://raw.githubusercontent.com/Niuttuc/ImperaMiniJeu/master/Common/Advanced%20Home%20Base%20(ahb).lua")
end

-- Mise a jour via pastebin
function majPastBin(nom)
	config=ahb.config("maj"..nom,{
		pastebin={typ="string"},
		prog={typ="string",defaut=nom}
	})
	majFichierParUrl(config.prog,"https://pastebin.com/raw/"..config.pastebin)
end

-- Mise a jour via gitHub
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

-- Debut du programme
local args={ ... }
-- Si pas d'arguement, maj complete
if (#args == 0) then
	majAHB()
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
		majAHB()
	end
	for i, prog in pairs(args) do
		if prog=='ahb' then
			majAHB()
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