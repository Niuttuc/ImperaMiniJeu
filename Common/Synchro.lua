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
	if type(list)=='table' and #list>0 then
		return table.remove(list,1),listArgs(list)
	elseif type(list)~=nil then
		return list
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
	actual[#actual+1]=coroutine.running()
	local id=0
	local funcArgs={}
	for i=1,#actual do
		if string.sub(tostring(actual[i]),9,-1)==string.sub(tostring(coroutine.running()),9,1) then
			print('foundit:',i)
			id=i
		end
	end
	print(id,type(id))
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
			if doublon==prec and args[i+1] and type(args[i+1]~=func) then
				funcArgs=args[i+1]
			else
				funcArgs={}
			end
		end
	end
	ret=func(listArgs(funcArgs))
end

function waitForAny(...)
	args={...}
	functions={keepFunc(...)}
	actual={}
	local endFunc=parallel.waitForAny(argRep(#functions,proxFunc))
	return ret,endFunc
end

function waitForAll(...)
	args={...}
	functions={keepFunc(...)}
	actual={}
	local endFunc=parallel.waitForAll(argRep(#functions,proxFunc))
	return ret,endFunc
end
