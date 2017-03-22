modem=peripheral.find('modem')
 
function updatePoints(pointsBleus,pointsRouges)
    redstone.setAnalogOutput('top', math.floor(pointsBleus/10))
    redstone.setAnalogOutput('front', pointsBleus%10)
    redstone.setAnalogOutput('left', math.floor(pointsRouges/10))
    redstone.setAnalogOutput('right', pointsRouges%10)
end
function waitCommands()
    modem.open(colors.purple)
    while true do
        ev,side,freq,repFreq,mess,dis=os.pullEvent('modem_message')
        if type(mess)=='table' and repFreq==colors.white then
            updatePoints(mess.blue,mess.red)
        elseif mess=='Reset' then
            updatePoints(0,0)
        end
    end
end
 
 
waitCommands()