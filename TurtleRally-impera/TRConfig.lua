print("LOAD Config v0.47")

local config=ahb.config("TR",{
	ecran={typ="side",info="Ecran principal"},
	modem={typ="side",info="Modem WIFI"},	
	laser={typ="side",info="Laser"},
	x={typ="string",info="Coordinne 0 0 0 X"},
	y={typ="string",info="Coordinne 0 0 0 Y"},
	z={typ="string",info="Coordinne 0 0 0 Z"},
	orientation={typ="coord",info="Orientation de X"},
	openperipheral={typ="boolean",info="Mod openperipheral dispo ?"}
})
config.tailleY=18
config.tailleX=14
config.vie=3
config.etape=4
config.coeur=10
config.time=20
config.partie=false
config.etapeTelecommande="NONLANCER"

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
	
	affichage.addConfig("time",3,"Temps")
	affichage.addChoix(1,'1  ',"time",false)
	affichage.addChoix(10,'10 ',"time",false)
	affichage.addChoix(20,'20 ',"time",false)
	affichage.addChoix(30,'30 ',"time",true)
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
	map.add(11,0,'mur')
	map.add(12,0,'mur')
	map.add(13,0,'mur')
	map.add(14,0,'mur')
	map.add(15,1,'mur')
	map.add(15,2,'mur')
	map.add(15,3,'mur')
	map.add(15,4,'mur')
	
	map.add(5,2,"bonus","monitor_6")
	map.add(9,2,"etape","monitor_11","MX",true)
	map.add(10,2,"mur")
	map.add(6,3,"pique")
	map.add(7,3,"mur")
	map.add(10,3,"laser","MX")
	map.add(11,3,"mur")
	map.add(12,3,"bonus","monitor_7")
	map.add(3,4,"etape","monitor_12","MX",false)
	map.add(4,4,"mur")
	map.add(12,4,"mur")
	map.add(2,5,"trou")
	map.add(2,5,"trou")
	map.add(3,5,"trou")
	map.add(2,6,"trou")
	map.add(3,6,"trou")
	map.add(5,6,"bonus","monitor_8")
	map.add(9,6,"bonus","monitor_9")
	map.add(13,6,"etape","monitor_13","MY",false)
	map.add(1,7,"bonus","monitor_10")
	map.add(6,7,"pique")
	map.add(7,7,"mur")
	map.add(8,7,"mur")
	map.add(9,7,"mur")
	map.add(10,7,"pique")
	map.add(13,7,"mur")
	map.add(6,8,"mur2","bleu","hb_interupteur_60")
	map.add(10,8,"mur2","rouge","hb_interupteur_62")
	map.add(4,9,"bout","bleu")
	map.add(6,9,"mur2","bleu","hb_interupteur_59")
	map.add(8,9,"etape","monitor_14","MY",true)
	map.add(10,9,"mur2","rouge","hb_interupteur_61")
	map.add(12,9,"bout","rouge")
	map.add(6,10,"pique")
	map.add(7,10,"mur")
	map.add(8,10,"mur")
	map.add(9,10,"mur")
	map.add(10,10,"pique")
	map.add(12,11,"bonus","monitor_15")
	map.add(1,12,"trou")
	map.add(2,12,"trou")
	map.add(3,12,"trou")
	map.add(1,13,"trou")
	map.add(2,13,"trou")
	map.add(3,13,"trou")
	map.add(12,12,"pique")
	
	map.add(13,12,"mur")
	map.add(14,12,"mur")
	
	map.add(6,13,"bonus","monitor_16")
	map.add(6,14,"pique")
	map.add(4,17,"mur")
	map.add(4,16,"depart","monitor_1",2,"MY")
	map.add(8,17,"mur")
	map.add(8,16,"depart","monitor_3",4,"MY")
	map.add(12,17,"mur")
	map.add(12,16,"depart","monitor_5",6,"MY")
	map.add(2,18,"mur")
	map.add(2,17,"depart","monitor_0",1,"MY")
	map.add(6,18,"mur")
	map.add(6,17,"depart","monitor_2",3,"MY")
	map.add(10,18,"mur")
	map.add(10,17,"depart","monitor_4",5,"MY")
	
	-- FINIR PAR LES TAPIS, LES ENREGISTRER DANS L'ORDRE D'ACTIVATION
	-- X Y TAPIS {mx=Mouvement en x,my=Mouvement en y,rot="non" ou "clockTurn" ou "trigoTurn"}
	map.addGroupeTapis('rond',{'0','1','2','3'})
	
	map.add(2,2,"tapis",{mx=0,my=1,rot="trigoTurn",red="rond"})
	map.add(3,2,"tapis",{mx=-1,my=0,rot="trigoTurn",red="rond"})
	map.add(2,3,"tapis",{mx=1,my=0,rot="trigoTurn",red="rond"})
	map.add(3,3,"tapis",{mx=0,my=-1,rot="trigoTurn",red="rond"})
	
	map.addGroupeTapis('bordel4',{'4','5','6','7'})
	
	map.add(7,6,"tapis",{mx=0,my=-1,rot="trigoTurn",red="bordel4"})
	map.add(7,5,"tapis",{mx=1,my=0,rot="clockTurn",red="bordel4"})
	map.add(8,5,"tapis",{mx=0,my=-1,rot="trigoTurn",red="bordel4"})
	map.add(8,4,"tapis",{mx=0,my=-1,rot="non",red="bordel4"})
	
	map.addGroupeTapis('bordel5',{'8','9','10','11','12'})
	
	map.add(11,6,"tapis",{mx=-1,my=0,rot="trigoTurn",red="bordel5"})
	map.add(10,6,"tapis",{mx=0,my=-1,rot="clockTurn",red="bordel5"})
	map.add(10,5,"tapis",{mx=-1,my=0,rot="trigoTurn",red="bordel5"})
	map.add(9,5,"tapis",{mx=0,my=-1,rot="clockTurn",red="bordel5"})
	map.add(9,4,"tapis",{mx=0,my=-1,rot="non",red="bordel5"})
	
	map.addGroupeTapis('bleu',{'19','20','21','22','23','24'})
	
	map.add(5,10,"tapis",{mx=-1,my=0,rot="non",red="bleu"})
	map.add(4,10,"tapis",{mx=-1,my=0,rot="non",red="bleu"})
	map.add(3,10,"tapis",{mx=0,my=-1,rot="clockTurn",red="bleu"})
	map.add(3,9,"tapis",{mx=0,my=-1,rot="non",red="bleu"})
	map.add(3,8,"tapis",{mx=1,my=0,rot="clockTurn",red="bleu"})
	map.add(4,8,"tapis",{mx=1,my=0,rot="non",red="bleu"})
	
	map.addGroupeTapis('rouge',{'13','14','15','16','17','18'})
	
	map.add(11,10,"tapis",{mx=1,my=0,rot="non",red="rouge"})
	map.add(12,10,"tapis",{mx=1,my=0,rot="non",red="rouge"})
	map.add(13,10,"tapis",{mx=0,my=-1,rot="trigoTurn",red="rouge"})
	map.add(13,9,"tapis",{mx=0,my=-1,rot="non",red="rouge"})
	map.add(13,8,"tapis",{mx=-1,my=0,rot="trigoTurn",red="rouge"})
	map.add(12,8,"tapis",{mx=-1,my=0,rot="non",red="rouge"})
	
	map.addGroupeTapis('ligne',{'25','26','27','28','29','30'})
	
	map.add(11,12,"tapis",{mx=1,my=0,rot="non",red="ligne"})
	map.add(10,12,"tapis",{mx=1,my=0,rot="non",red="ligne"})
	map.add(9,12,"tapis",{mx=1,my=0,rot="non",red="ligne"})
	map.add(8,12,"tapis",{mx=1,my=0,rot="non",red="ligne"})
	map.add(7,12,"tapis",{mx=1,my=0,rot="non",red="ligne"})
	map.add(6,12,"tapis",{mx=1,my=0,rot="non",red="ligne"})	
	
	-- FINIR PAR LES PLAQUES TOURNANTE
	-- X Y pt "clockTurn" ou "trigoTurn"
	
	map.addGroupeTapis('laby',{'45','48','49','50','46','47','52','51','53','54','55','56'})
	
	map.add(11,1,"pt","trigoTurn",'laby')
	map.add(12,1,"pt","clockTurn",'laby')
	map.add(13,1,"pt","trigoTurn",'laby')
	map.add(14,1,"pt","clockTurn",'laby')
	
	map.add(11,2,"pt","clockTurn",'laby')
	map.add(12,2,"pt","trigoTurn",'laby')
	map.add(13,2,"pt","clockTurn",'laby')
	map.add(14,2,"pt","trigoTurn",'laby')	
	
	map.add(13,3,"pt","trigoTurn",'laby')
	map.add(14,3,"pt","clockTurn",'laby')
	
	map.add(13,4,"pt","clockTurn",'laby')
	map.add(14,4,"pt","trigoTurn",'laby')
	
	map.addGroupeTapis('iso1',{'44'})	
	map.add(7,2,"pt","trigoTurn","iso1")
	
	map.addGroupeTapis('iso2',{'43'})	
	map.add(5,3,"pt","clockTurn","iso2")
	
	
	map.addGroupeTapis('iso3',{'42'})	
	map.add(5,5,"pt","trigoTurn","iso3")
	
	map.addGroupeTapis('iso4',{'41'})	
	map.add(4,6,"pt","trigoTurn","iso4")
	
		
	map.addGroupeTapis('iso5',{'58'})
	map.add(1,8,"pt","trigoTurn","iso5")
	
	map.addGroupeTapis('etape',{'38','39','40'})
	map.add(8,8,"pt","trigoTurn",'etape')
	map.add(7,9,"pt","trigoTurn",'etape')
	map.add(9,9,"pt","clockTurn",'etape')
	
	map.addGroupeTapis('iso6',{'37'})
	map.add(4,12,"pt","trigoTurn","iso6")
	
	map.addGroupeTapis('departs',{'31','32','33','34','35','36'})
	map.add(2,15,"pt","clockTurn","departs")
	map.add(4,14,"pt","clockTurn","departs")
	map.add(6,15,"pt","trigoTurn","departs")
	map.add(8,14,"pt","trigoTurn","departs")
	map.add(10,15,"pt","clockTurn","departs")
	map.add(12,14,"pt","clockTurn","departs")
	
	
end

local ordiReboot={
	"computer_2", -- GPS
	"computer_3", -- GPS
	"computer_4", -- GPS
	"computer_5", -- GPS
	"computer_6", -- Lanceur de turtle
	"computer_7", -- Lanceur de turtle
	"computer_8", -- Lanceur de turtle
	"computer_9", -- Lanceur de turtle
	"computer_10", -- Lanceur de turtle
	"computer_11", -- Lanceur de turtle
}
for ior=1,#ordiReboot do
	local test=ahb.addPeripheral(ordiReboot[ior])
	if test.pp.isOn() then
		test.pp.reboot()
	else
		test.pp.turnOn()		
	end
end