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
	print(fichier.." < "..url)
	local content = http.get(url)
	local file = fs.open(fichier,"w")
	file.write(content.readAll())
	file.close()
end

-- Recupere le programme ahb
function majAHB()
	majFichierParUrl("ahb","https://raw.githubusercontent.com/Niuttuc/ImperaMiniJeu/master/Common/Advanced%20Home%20Base%20(ahb).lua")
end

-- Configuration des plateformes
local plateforme={
	github=function(nom)
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
			prog={typ="string",info="Nom du fichier pour CC",defaut=nom}
		})
		majFichierParUrl(config.prog,"https://raw.githubusercontent.com/"..config.user.."/"..config.repository.."/"..config.branch.."/"..config.file.."?t"..os.day()..os.time())
	end,
	pastebin=function(nom)
		config=ahb.config("maj"..nom,{
			pastebin={typ="string",info="Identifiant pastbin"},
			prog={typ="string",info="Nom du fichier pour CC",defaut=nom}
		})
		majFichierParUrl(config.prog,"https://pastebin.com/raw/"..config.pastebin)
	end,
	site=function(nom)
		confiSite=ahb.config("siteDef",{
			url={typ="string",info="Url principal"},
		})
		config=ahb.config("maj"..nom,{
			url={typ="string",info="Url hebergement ",defaut=confiSite.url},
			fichier={typ="string",info="Nom du fichier"},
			prog={typ="string",info="Nom du fichier pour CC",defaut=nom}
		})
		majFichierParUrl(config.prog,config.url..config.fichier.."?t"..os.day()..os.time())
	end
}

-- Debut du programme
local args={ ... }
-- Si pas d'arguement, maj complete
if (#args == 0) then
	majAHB()
	os.loadAPI("ahb")
	config=ahb.config("majs",{liste={typ="table"}})
	for prog, site in pairs(config.liste) do
		if plateforme[site] then
			plateforme[site](prog)
		else
			error("Plateforme non trouve "..site)
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
				term.write("Nouveau programme "..prog)
				
				local curs=2
				for nomPf, fc in pairs(plateforme) do
					term.setCursorPos(2,curs)
					term.write(nomPf)
					curs=curs+1
				end
				
				local bool=true
				while bool do
					ev,button,x,y=os.pullEvent("mouse_click")
					local curs=2
					for nomPf, fc in pairs(plateforme) do
						if y==curs then
							ahb.configTab('majs','liste','add',prog,nomPf)
							config.liste[prog]=nomPf
							bool=false
						end
						curs=curs+1
					end		
				end				
			end
			
			if plateforme[config.liste[prog]] then
				plateforme[config.liste[prog]](prog)
			else
				error("Site non config "..args[1])
			end
		end
	end
end