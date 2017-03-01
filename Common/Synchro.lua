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
	print("OH")
	actual[#actual+1]=coroutine.running()
	local id=0
	for i=1,#actual do
		if actual[i]==coroutine.running() then
			id=i
		end
	end
	local func=functions[id]
	ret={func(listArgs(args[id]))}
end
-- waitForAny({function1,function2},{args1,args2})
function waitForAny(f,a)
	functions=f
	args=a
	actual={}
	local endFunc=parallel.waitForAny(argRep(#functions,proxFunc))
	return endFunc,listArgs(ret)
end

function waitForAll(f,a)
	args=a
	functions=f
	actual={}
	parallel.waitForAll(argRep(#functions,proxFunc))
	return listArgs(ret)
end
