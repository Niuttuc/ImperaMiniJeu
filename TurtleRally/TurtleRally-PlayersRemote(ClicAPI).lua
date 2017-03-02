
function waitCLic(xstart,ystart,xend,yend,func,...)
	monitor_side=...
	if monitor_side and peripheral.isPresent(monitor_side) then
		while true do
			ev,side,x,y=os.pullEvent('monitor_touch')
			if x>=xstart and x<=xend and y>=ystart and y<=yend and side==monitor_side then
				func()
				return true
			end
		end
		return false
	else
		while true do
			ev,button,x,y=os.pullEvent('mouse_click')
			if x>=xstart and x<=xend and y>=ystart and y<=yend then
				term.write(" est ok")
				func()
				return true
			end
		end
		return false
	end
end 