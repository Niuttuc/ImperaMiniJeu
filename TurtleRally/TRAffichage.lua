print("LOAD Affichage v0.03")

local ecran=config.ecran()
local ecranW, ecranH = ecran.pp.getSize()

ecran.pp.clear()

local boutonLancement=window.create(ecran.pp,ecranW-12,ecranH-3,12,3,true)
boutonLancement.setBackgroundColor(colors.yellow)
boutonLancement.clear()
boutonLancement.setTextColor(colors.white)
ahb.center("Lancer",boutonLancement,2)

local fenetreConfig=window.create(ecran.pp,1,ecranH-1,16,3,true)
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
	fenetreConfig.reposition(1,ecranH-hauteur,16,hauteur)
end
function addChoix(val,c,def) 
	local data={
		fenetre=window.create(fenetreConfig,16+(#choix[c].liste*3),choix[c].y,3,1,true),
		val=val,
		def=def
	}
	ahb.center(tostring(val),data.fenetre,1)
	table.insert(choix[c].liste,data)
	local m=0
	for c, d in pairs(choix) do
		m=math.max(m,#d.liste)
	end
	largeur=16+(m*3)
	fenetreConfig.reposition(1,ecranH-hauteur,largeur,hauteur)
end

function attenteLancement()
	config.set("partie",false)
	for c, d in pairs(choix) do
		for i=1, #d.liste do
			if d.liste[i].def then
				d.liste[i].fenetre.setBackgroundColor(colors.yellow)
				d.liste[i].fenetre.redraw()
				config.set(d.c,d.liste[i].val)
			else
				d.liste[i].fenetre.setBackgroundColor(colors.black)
				d.liste[i].fenetre.redraw()
			end
		end
	end
	while not(config.get("partie")) do
		event, ecranN, xPos, yPos = os.pullEvent("monitor_touch")
		if xPos>=ecranW-12 and yPos<=ecranH-3 then
			if joueur.actifs()>=2 then
				config.set("partie",true)
			end
		else
			for c, d in pairs(choix) do
				if yPos==ecranH-hauteur+d.y then
					if xPos>=16 then
						for i=1, #d.liste do
							if xPos>=16+((i-1)*3) and xPos<16+(i*3) then
								for i2=1, #d.liste do
									if i==i2 then
										d.liste[i].fenetre.setBackgroundColor(colors.yellow)
										d.liste[i].fenetre.redraw()
										config.set(d.c,d.liste[i].val)
									else
										d.liste[i].fenetre.setBackgroundColor(colors.black)
										d.liste[i].fenetre.redraw()
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
