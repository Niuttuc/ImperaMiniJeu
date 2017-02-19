print("LOAD Affichage v0.04")

local ecran=config.ecran()
local ecranW, ecranH = ecran.pp.getSize()
local largeurConf=12

ecran.pp.clear()

local boutonLancement=window.create(ecran.pp,ecranW-12,ecranH-3,12,3,false)
boutonLancement.setBackgroundColor(colors.yellow)
boutonLancement.clear()
boutonLancement.setTextColor(colors.white)
ahb.center("Lancer",boutonLancement,2)

local fenetreConfig=window.create(ecran.pp,1,ecranH-1,largeurConf,3,false)
fenetreConfig.setBackgroundColor(colors.red)
fenetreConfig.setTextColor(colors.white)
fenetreConfig.clear()

local hauteur=0
local largeur=0
local choix={}
function addConfig(c,y,nom)
	fenetreConfig.setCursorPos(1,y)
	fenetreConfig.write(nom)
	choix[c]={
		liste={},
		c=c,
		y=y
	}
	hauteur=hauteur+1	
end
function addChoix(val,aff,c,def) 
	local data={
		fenetre=window.create(fenetreConfig,largeurConf+(#choix[c].liste*3),choix[c].y,3,1,true),
		val=val,
		aff=aff,
		def=def
	}
	data.fenetre.write(aff)
	table.insert(choix[c].liste,data)
	local m=0
	for c, d in pairs(choix) do
		m=math.max(m,#d.liste)
	end
	largeur=largeurConf+((m-1)*3)	
end
function actuFenetre(fenetre,aff,couleur)
	fenetre.setBackgroundColor(couleur)
	fenetre.clear()
	fenetre.setCursorPos(1,1)
	print("-"..aff.."-")
	fenetre.write(aff)
end
function attenteLancement()
	config.set("partie",false)
	ecran.pp.clear()
	print(largeur.." "..hauteur)
	fenetreConfig.reposition(1,ecranH-hauteur,largeur,hauteur)
	fenetreConfig.setVisible(true)
	for c, d in pairs(choix) do
		for i=1, #d.liste do
			if d.liste[i].def then
				actuFenetre(d.liste[i].fenetre,d.liste[i].aff,colors.yellow)
				config.set(d.c,d.liste[i].val)
			else
				actuFenetre(d.liste[i].fenetre,d.liste[i].aff,colors.black)
				d.liste[i].fenetre.write(d.liste[i].aff)
			end
		end
	end
	boutonLancement.setVisible(true)
	while not(config.get("partie")) do
		event, ecranN, xPos, yPos = os.pullEvent("monitor_touch")
		print("Cliquer "..xPos.." "..yPos)
		print((ecranW-12).." "..(ecranH-3))
		if xPos>=ecranW-12 and yPos>=ecranH-3 then
			print("Bouton")
			if joueur.actifs()>=2 then
				config.set("partie",true)
			end
		else
			for c, d in pairs(choix) do
				if yPos==ecranH-hauteur+d.y then
					print("Config "..c)
					if xPos>=largeurConf then
						for i=1, #d.liste do
							if xPos>=largeurConf+((i-1)*3) and xPos<largeurConf+(i*3) then
								print("Option "..c)
								for i2=1, #d.liste do
									if i==i2 then
										actuFenetre(d.liste[i].fenetre,d.liste[i].aff,colors.yellow)
										config.set(d.c,d.liste[i].val)
									else
										actuFenetre(d.liste[i].fenetre,d.liste[i].aff,colors.black)
									end
								end
							end
						end
					end
				end
			end
		end
	end
	fenetreConfig.setVisible(false)
	boutonLancement.setVisible(false)
end
