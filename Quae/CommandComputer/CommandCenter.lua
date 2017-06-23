os.loadAPI("commandAPI")
chat=peripheral.find("chatBox")

function addMembre(player,args)
 	for i=1,#args do
		commands.p("user",args[i],"group","set","membre")
		chat.tell(args[i],"Vous etes desormais Membre d'Imperacube! Felicitations!",100000,true,"Imperacube")
		chat.tell(args[i],args[i].." est desormais Membre d'Imperacube!",100000,true,"Imperacube")
	end
end

commandAPI.addCommand("membre","_OPS_",addMembre)
commandAPI.waitCommands()