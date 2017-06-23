groups={"_ALL_","_GUESTS_","membre","_OPS_"}
chat=peripheral.find("chatBox")

function stop()
	error('Arret utilisateur')
end
commands={["stop"]={["group"]="_OPS_",["func"]=stop }}

function addCommand(command,group,func)
	commands[command]={["group"]=group,["func"]=func}
end

function waitCommands()
	while true do
		ev,player,args=os.pullEvent("command")
		if commands[args[1]] then
			command=args[1]
			table.remove(args,1)
			whatever,playerGroups=commands.p('user',player)
			for i=2,#playerGroups do
				if string.sub(playerGroups[i],3,-1)==commands[args[1]].group then
					commands[args[1]].func()
				end
			end
		end
	end
end
