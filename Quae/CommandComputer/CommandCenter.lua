os.loadAPI("commandAPI")
chat=peripheral.find("chatBox")

function addMembre(player,args)
 	for i=1,#args do
		commands.p("user",args[i],"group","set","membre")
		chat.tell(args[i],"Vous etes desormais Membre d'Imperacube! Felicitations!",100000,true,"Imperacube")
		chat.tell(args[i],args[i].." est desormais Membre d'Imperacube!",100000,true,"Imperacube")
	end
end
function tpOlymcube(player,args)
	commands.mwtp("Olymcube",player,"-7 9 8")
end
commandAPI.addCommand("membre","_OPS_",addMembre)
commandAPI.addCommand("olymcube","_ALL_",tpOlymcube)
commandAPI.addCommand("ol","_ALL_",tpOlymcube)
commandAPI.addCommand("oc","_ALL_",tpOlymcube)

commandAPI.waitCommands()