groups={"_ALL_","_GUESTS_","membre","_OPS_"}
chat=peripheral.find("chatBox")

function stop(...)
	error('Arret utilisateur')
end
storedCommands={["stop"]={["group"]="_OPS_",["func"]=stop }}

function addCommand(command,group,func)
	storedCommands[command]={["group"]=group,["func"]=func}
end
function listArgs(list)
	local list2=list
	if type(list2)=='table' and #list2>0 then
		return table.remove(list2,1),listArgs(list2)
	elseif type(list2)~=nil then
		return list2
	end
	return nil
end

function waitCommands()
	while true do
		ev,player,args=os.pullEvent("command")
		if storedCommands[args[1]] then
			command=args[1]
			table.remove(args,1)
			whatever,playerGroups=commands.p('user',player)
			for i=2,#playerGroups do
				if string.sub(playerGroups[i],3,-1)==storedCommands[command].group then
					storedCommands[command].func(player,args)
				end
			end
		end
	end
end
