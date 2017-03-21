file=fs.open('sidesColors','r')
sidesColors=textutils.unserialise(file.readAll())
file.close()
file=fs.open('roomNumber','r')
j=tonumber(file.readLine())
file.close()
mod=peripheral.find('modem')
isRoomActive=false
 
 
 
function liftAndWait(side)
    cible=sidesColors[side][math.random(#sidesColors[side])]
    redstone.setBundledOutput(side, colors.combine(redstone.getBundledOutput(side),cible[1]))
    while true do
        ev=os.pullEvent('redstone')
        if colors.test(redstone.getBundledInput(side),cible[2]) then
            redstone.setBundledOutput(side, colors.subtract(redstone.getBundledOutput(side),cible[1]))
            return 1
        end
    end
   
end
function liftRandomAndWait()
    local c=0
    for k,v in pairs(sidesColors) do
        c=c+1
    end
    local score=0
 
    while true do
        if isRoomActive then
            rand=math.random(c)
            local i=1
            for k,v in pairs(sidesColors) do
                if i==rand then
                    liftAndWait(k)
                    mod.transmit(42,j,1)
                end
                i=i+1
            end
        else
            sleep(1)
        end
    end
end
 
 
function listen()
    mod.open(j)
    while true do
        ev,side,freq,repFreq,mes,dis=os.pullEvent('modem_message')
        if freq==j and repFreq==42 then
            if mes=='startRoom' then
                isRoomActive=true
                mod.transmit(42,j,tostring(j)..' ok')
            elseif mes=='stopRoom' then
                isRoomActive=false
                redstone.setBundledOutput('left', 0)
                redstone.setBundledOutput('right', 0)
                redstone.setBundledOutput('top', 0)
                redstone.setBundledOutput('bottom', 0)
                redstone.setBundledOutput('back', 0)
                redstone.setBundledOutput('front', 0)
                mod.transmit(42,j,tostring(j)..' finished')
                mod.close(j)
                return true
            end
        end
    end
end
 
 
 
 
 
 
 
 
 
while true do
    parallel.waitForAny(liftRandomAndWait,listen)
end