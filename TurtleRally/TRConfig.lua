print("LOAD Config v0.12")

local config=ahb.config("TR",{
	ecran={typ="side",info="Ecran principal"},
	modem={typ="side",info="Modem WIFI"},
	redstone={typ="side",info="Redstone pour mur"}
})
config.tailleY=18
config.tailleX=14
config.vie=3
config.etape=4
config.coeur=10
config.partie=false

function get(id)
	return config[id]
end
function set(id,val)
	config[id]=val
end

local ecranP=ahb.addPeripheral(config.ecran)
function ecran()
	return ecranP
end
function ecranPP()
	return ecranP.pp
end
local modemP=ahb.addPeripheral(config.modem)
function modem()
	return modemP
end

function affichageConf()
	affichage.addConfig("vie",1,"Nb de vie")
	affichage.addChoix(1,' 1 ',"vie",false)
	affichage.addChoix(3,' 3 ',"vie",true)
	affichage.addChoix(9,' 9 ',"vie",false)

	affichage.addConfig("etape",2,"Nb d'etape")
	affichage.addChoix(1,' 1 ',"etape",false)
	affichage.addChoix(2,' 2 ',"etape",false)
	affichage.addChoix(3,' 3 ',"etape",false)
	affichage.addChoix(4,' 4 ',"etape",true)
end
function joueurDef()
	joueur.configFenetre(affichage.fenetreJoueurs(),affichage.ecranLargeur())
	joueur.configJ(colors.yellow,"Jaune",2)
	joueur.configJ(colors.pink,"Rose",3)
	joueur.configJ(colors.brown,"Marron",4)
	joueur.configJ(colors.purple,"Violet",5)
	joueur.configJ(colors.blue,"Bleu",6)
	joueur.configJ(colors.green,"Vert",7)
end
function mapDef()
	-- Liste et config X Y TYPE PARAM
	-- bonus selector_id_periph
	-- etape monitor_id_periph
	-- mur
	-- laser
	-- pique
	-- depart monitor_id_periph idDepart
	-- mur2 couleur
	-- bout couleur
	map.add(5,2,"bonus","openperipheral_selector_84")
	map.add(9,2,"etape","monitor_27")
	map.add(10,2,"mur")
	map.add(7,3,"mur")
	map.add(8,3,"laser")
	map.add(9,3,"laser")
	map.add(10,3,"mur")
	map.add(11,3,"mur")
	map.add(12,3,"bonus","openperipheral_selector_83")
	map.add(3,4,"etape","monitor_18")
	map.add(4,4,"mur")
	map.add(2,5,"trou")
	map.add(3,5,"trou")
	map.add(2,6,"trou")
	map.add(3,6,"trou")
	map.add(5,6,"bonus","openperipheral_selector_82")
	map.add(9,6,"bonus","openperipheral_selector_78")
	map.add(13,6,"etape","monitor_25")
	map.add(1,7,"bonus","openperipheral_selector_81")
	map.add(6,7,"pique")
	map.add(7,7,"mur")
	map.add(8,7,"mur")
	map.add(9,7,"mur")
	map.add(10,7,"pique")
	map.add(13,7,"mur")
	map.add(6,8,"mur2","bleu")
	map.add(10,8,"mur2","rouge")
	map.add(3,9,"bout","bleu")
	map.add(6,9,"mur2","bleu")
	map.add(8,9,"etape","monitor_26")
	map.add(10,9,"mur2","rouge")
	map.add(13,9,"bout","rouge")
	map.add(6,10,"pique")
	map.add(7,10,"mur")
	map.add(8,10,"mur")
	map.add(9,10,"mur")
	map.add(10,10,"pique")
	map.add(12,11,"bonus","openperipheral_selector_80")
	map.add(2,12,"trou")
	map.add(3,12,"trou")
	map.add(2,13,"trou")
	map.add(3,13,"trou")
	map.add(12,12,"pique")
	map.add(6,13,"bonus","openperipheral_selector_79")
	map.add(6,14,"pique")
	map.add(4,17,"mur")
	map.add(4,16,"depart","monitor_23",2)
	map.add(8,17,"mur")
	map.add(8,16,"depart","monitor_21",4)
	map.add(12,17,"mur")
	map.add(12,16,"depart","monitor_19",6)
	map.add(2,18,"mur")
	map.add(2,17,"depart","monitor_24",1)
	map.add(6,18,"mur")
	map.add(6,17,"depart","monitor_22",3)
	map.add(10,18,"mur")
	map.add(10,17,"depart","monitor_20",5)
	
	-- FINIR PAR LES TAPIS, LES ENREGISTRER DANS L'ORDRE D'ACTIVATION
	-- X Y TAPIS {mx=Mouvement en x,my=Mouvement en y,rot="NON" ou "clockTurn" ou "trigoTurn"}
	map.add(11,12,"tapis",{mx=1,my=0,rot="non"})
	map.add(10,12,"tapis",{mx=1,my=0,rot="non"})
	map.add(9,12,"tapis",{mx=1,my=0,rot="non"})
	map.add(8,12,"tapis",{mx=1,my=0,rot="non"})
	map.add(7,12,"tapis",{mx=1,my=0,rot="non"})
	
	map.add(8,4,"tapis",{mx=0,my=-1,rot="non"})
	map.add(8,5,"tapis",{mx=0,my=-1,rot="non"})
	
	-- FINIR PAR LES PLAQUES TOURNANTE
	-- X Y pt "clockTurn" ou "trigoTurn"
end

local ordiReboot={
	"computer_15", -- GPS
	"computer_16", -- GPS
	"computer_17", -- GPS
	"computer_18", -- GPS
	"computer_27", -- Lanceur de turtle
	"computer_28", -- Lanceur de turtle
	"computer_29", -- Lanceur de turtle
	"computer_30", -- Lanceur de turtle
	"computer_31", -- Lanceur de turtle
	"computer_32", -- Lanceur de turtle
}
for ior=1,#ordiReboot do
	local test=ahb.addPeripheral(ordiReboot[ior])
	if test.isOn() then
		test.pp.reboot()
	else
		test.pp.turnOn()		
	end
end