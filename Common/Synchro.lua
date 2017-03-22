function keepFunc(first,...)
	if type(first)=='function' then
		return first,keepFunc(...)
	elseif type(first)=='nil' then
		return nil
	else
		return keepFunc(...)
	end
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


function argRep(n,arg)
	if n>0 then
		return arg,argRep(n-1,arg)
	end
	return nil
end


function proxFunc()
	current[#current+1]=coroutine.running()
	local id=0
	local funcArgs={}
	for i=1,#current do
		if current[i]==coroutine.running() then
			id=i
		end
	end
	local func=functions[id]
	local prec=0
 	for i=1,id do
 		if functions[i]==func then
 			prec=prec+1
 		end
 	end
 	local doublon=0
 	for i=1,#args do
 		if args[i]==func then
 			doublon=doublon+1
 			if doublon==prec and args[i+1] and type(args[i+1])~=func then
 				funcArgs=args[i+1]
 			elseif doublon<prec or (doublon==prec and (not(args[i+1]) or type(args[i+1])==func)) then
 				funcArgs={}
 			end
 		end
 	end
 	ret={func(listArgs(funcArgs))}
end

function waitForAny(...)
 	args={...}
	functions={keepFunc(...)}
	current={}
	local endFunc=parallel.waitForAny(argRep(#functions,proxFunc))
	return endFunc,listArgs(ret)
end


function waitForAll(...)
 	args={...}
 	functions={keepFunc(...)}
	current={}
	parallel.waitForAll(argRep(#functions,proxFunc))
	return listArgs(ret)
end
